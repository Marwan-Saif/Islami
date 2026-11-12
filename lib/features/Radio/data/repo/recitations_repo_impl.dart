import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:islami/core/services/app_settings.dart';
import 'package:islami/core/services/shared_prefs.dart';
import 'package:islami/features/Radio/data/models/reciter_model.dart';
import 'package:islami/features/Radio/domain/recitations_repo.dart';

class RecitationsRepoImpl implements RecitationsRepo {
  static const String _lastSelectionKey = 'last_recitation';

  // الـ API بيرجع أسماء القراء والروايات باللغة المطلوبة
  static String get _language => AppSettings.instance.isArabic ? 'ar' : 'eng';
  static String get _recitersUrl =>
      'https://www.mp3quran.net/api/v3/reciters?language=$_language';
  static String get _cacheKey =>
      _language == 'ar' ? 'reciters_cache' : 'reciters_cache_$_language';

  // القارئ الافتراضي قبل ما المستخدم يختار، عشان "اختيار التلاوة" يشتغل من غير نت
  static ReciterModel get _defaultReciter {
    final arabic = AppSettings.instance.isArabic;
    return ReciterModel(
      id: 123,
      name: arabic ? 'مشاري العفاسي' : 'Mishary Alafasy',
      moshaf: [
        MoshafModel(
          id: 123,
          name: arabic
              ? 'حفص عن عاصم - مرتل'
              : 'Rewayat Hafs A\'n Assem - Murattal',
          server: 'https://server8.mp3quran.net/afs/',
          surahList: List.generate(114, (index) => index + 1),
        ),
      ],
    );
  }

  List<ReciterModel>? _reciters;
  String? _recitersLanguage;

  @override
  Future<List<ReciterModel>> getReciters() async {
    // القائمة المتخزنة في الذاكرة بتتبني من جديد لو اللغة اتغيرت
    final language = _language;
    if (_reciters != null && _recitersLanguage == language) return _reciters!;
    try {
      final response = await http
          .get(Uri.parse(_recitersUrl))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        throw Exception('status code ${response.statusCode}');
      }
      final body = utf8.decode(response.bodyBytes);
      _reciters = _parse(body);
      // نسخة محفوظة عشان القائمة تفتح لو النت فصل بعد كده
      await Prefs.saveData(key: _cacheKey, value: body);
    } catch (e) {
      log('failed to load reciters, using cache: $e');
      // من غير نت ومفيش نسخة باللغة دي، القائمة العربية أحسن من مفيش
      final String? cached =
          Prefs.getData(key: _cacheKey) ?? Prefs.getData(key: 'reciters_cache');
      if (cached == null) rethrow;
      _reciters = _parse(cached);
    }
    _recitersLanguage = language;
    return _reciters!;
  }

  List<ReciterModel> _parse(String body) {
    final json = jsonDecode(body) as Map<String, dynamic>;
    return [
      for (var item in json['reciters'] as List) ReciterModel.fromJson(item),
    ]..removeWhere((reciter) => reciter.moshaf.isEmpty);
  }

  @override
  ({ReciterModel reciter, MoshafModel moshaf}) getLastSelection() {
    final String? saved = Prefs.getData(key: _lastSelectionKey);
    if (saved != null) {
      try {
        final json = jsonDecode(saved) as Map<String, dynamic>;
        final reciter = ReciterModel.fromJson(json['reciter']);
        final moshaf = MoshafModel.fromJson(json['moshaf']);
        // الاختيار بيتحفظ بالأسماء باللغة اللي اتختار بيها، فبنجيب الأسماء
        // من قائمة اللغة الحالية لو موجودة (كان القارئ بيفضل بالعربي في الإنجليزي)
        final localized = _localizedReciters();
        final current = localized?.where((r) => r.id == reciter.id).firstOrNull;
        final currentMoshaf = current?.moshaf
            .where((m) => m.id == moshaf.id)
            .firstOrNull;
        if (current != null && currentMoshaf != null) {
          return (reciter: current, moshaf: currentMoshaf);
        }
        return (reciter: reciter, moshaf: moshaf);
      } catch (e) {
        log('invalid saved recitation: $e');
      }
    }
    return (reciter: _defaultReciter, moshaf: _defaultReciter.moshaf.first);
  }

  /// قائمة القراء باللغة الحالية من الذاكرة أو من النسخة المحفوظة
  /// (بتتقرا من Prefs مرة واحدة لكل لغة)، أو null لو مفيش نسخة باللغة دي
  // متغيرات منفصلة عن _reciters عشان getReciters يفضل يحدّث من النت
  List<ReciterModel>? _cachedReciters;
  String? _cachedLanguage;

  List<ReciterModel>? _localizedReciters() {
    final language = _language;
    if (_reciters != null && _recitersLanguage == language) return _reciters;
    if (_cachedReciters != null && _cachedLanguage == language) {
      return _cachedReciters;
    }
    final String? cached = Prefs.getData(key: _cacheKey);
    if (cached == null) return null;
    try {
      _cachedReciters = _parse(cached);
      _cachedLanguage = language;
      return _cachedReciters;
    } catch (e) {
      log('invalid reciters cache: $e');
      return null;
    }
  }

  @override
  Future<void> saveLastSelection(
    ReciterModel reciter,
    MoshafModel moshaf,
  ) async {
    await Prefs.saveData(
      key: _lastSelectionKey,
      value: jsonEncode({
        'reciter': reciter.toJson(),
        'moshaf': moshaf.toJson(),
      }),
    );
  }
}
