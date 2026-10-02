import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:islami/core/services/app_settings.dart';
import 'package:islami/features/Hadith/data/hadith_books.dart';
import 'package:islami/features/Hadith/data/hadith_models.dart';

/// نصوص الأحاديث من hadith-api (https://github.com/fawazahmed0/hadith-api)
/// كل باب بيتنزل مرة واحدة ويتخزن، فبيفتح بعد كده من غير نت
class HadithRepo {
  HadithRepo._();
  static final HadithRepo instance = HadithRepo._();

  static const String _baseUrl =
      'https://cdn.jsdelivr.net/gh/fawazahmed0/hadith-api@1/editions';
  // LazyBox عشان الأبواب المتخزنة متتحملش كلها في الذاكرة مع فتح الـ box
  static const String _cacheBoxName = 'hadith_cache';
  static const String _favoritesBoxName = 'hadith_favorites';

  LazyBox<String>? _cache;
  Box? _favorites;

  /// بيزيد مع أي تغيير في المفضلة
  final ValueNotifier<int> favoritesChanges = ValueNotifier(0);

  HadithBook bookByKey(String key) =>
      kHadithBooks.firstWhere((book) => book.key == key);

  Future<List<Hadith>> getSection(HadithBook book, HadithSection section) async {
    // الترجمة الإنجليزية من نفس المصدر وبنفس ترقيم الأحاديث،
    // ولو الباب مش متاح بالإنجليزي (أو مفيش نت ومش متخزن) بنرجع للعربي
    if (!AppSettings.instance.isArabic) {
      try {
        return await _loadSection('eng', book, section);
      } catch (_) {}
    }
    return _loadSection('ara', book, section);
  }

  Future<List<Hadith>> _loadSection(
    String language,
    HadithBook book,
    HadithSection section,
  ) async {
    final url =
        '$_baseUrl/$language-${book.key}/sections/${section.number}.min.json';
    final cache = _cache ??= await Hive.openLazyBox<String>(_cacheBoxName);
    var body = await cache.get(url);
    if (body == null) {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) {
        throw Exception('status code ${response.statusCode}');
      }
      body = utf8.decode(response.bodyBytes);
      await cache.put(url, body);
    }
    final json = body;
    // بعض الأبواب حجمها مئات الكيلوبايت فالـ parsing بيتعمل برا الـ UI thread
    return Isolate.run(() => _parse(json, book.key));
  }

  static List<Hadith> _parse(String body, String bookKey) {
    final data = jsonDecode(body) as Map<String, dynamic>;
    return [
      for (final item in data['hadiths'] as List)
        if ((item['text'] as String).trim().isNotEmpty)
          Hadith(
            bookKey: bookKey,
            number: item['hadithnumber'] as num,
            text: (item['text'] as String).trim(),
          ),
    ];
  }

  // ---------- المفضلة ----------
  Future<Box> _favoritesBox() async =>
      _favorites ??= await Hive.openBox(_favoritesBoxName);

  String _favoriteKey(Hadith hadith) => '${hadith.bookKey}_${hadith.number}';

  Future<List<Hadith>> getFavorites() async {
    final box = await _favoritesBox();
    return [for (final item in box.values) Hadith.fromJson(item as Map)].reversed.toList();
  }

  Future<bool> isFavorite(Hadith hadith) async =>
      (await _favoritesBox()).containsKey(_favoriteKey(hadith));

  /// بترجع true لو اتضاف، false لو اتشال
  Future<bool> toggleFavorite(Hadith hadith) async {
    final box = await _favoritesBox();
    final key = _favoriteKey(hadith);
    final added = !box.containsKey(key);
    added ? await box.put(key, hadith.toJson()) : await box.delete(key);
    favoritesChanges.value++;
    return added;
  }
}
