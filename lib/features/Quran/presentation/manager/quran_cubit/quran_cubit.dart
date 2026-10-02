import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami/features/Quran/domain/quran_repo.dart';
import 'package:quran_with_tafsir/quran_with_tafsir.dart';

part 'quran_state.dart';

class QuranCubit extends Cubit<QuranState> {
  QuranCubit(this.quranRepo) : super(QuranInitial());
  final QuranRepo quranRepo;
  List<SurahMetadata> _allSurahs = [];

  void getQuran() {
    _allSurahs = quranRepo.getSurahs();
    emit(GetQuranSuccess(_allSurahs));
  }

  /// بحث باسم السورة (عربي من غير تشكيل أو إنجليزي) أو برقمها
  void search(String query) {
    if (_allSurahs.isEmpty) return;
    final arabicQuery = normalizeArabic(query);
    final englishQuery = _normalizeEnglish(query);
    final number = int.tryParse(query.trim());

    if (number == null && arabicQuery.isEmpty && englishQuery.isEmpty) {
      emit(GetQuranSuccess(_allSurahs));
      return;
    }
    emit(GetQuranSuccess(_allSurahs.where((surah) {
      if (number != null) return surah.number == number;
      return (arabicQuery.isNotEmpty &&
              normalizeArabic(surah.nameAr).contains(arabicQuery)) ||
          (englishQuery.isNotEmpty &&
              _normalizeEnglish(surah.nameEn).contains(englishQuery));
    }).toList()));
  }

  // بيشيل التشكيل وكلمة "سورة" وبيوحد أشكال الألف والتاء المربوطة
  static String normalizeArabic(String text) => text
      .replaceAll(RegExp('[ؐ-ًؚ-ٰٟۖ-ۭـ]'), '')
      .replaceAll('سورة', '')
      .replaceAll(RegExp('[أإآٱ]'), 'ا')
      .replaceAll('ة', 'ه')
      .replaceAll('ى', 'ي')
      .replaceAll(RegExp(r'[^ء-ي]'), '');

  // أسماء الباكدج فيها حروف زي "Al-Fātiḥah"، فبنحولها لحروف عادية الأول
  static const Map<String, String> _latinFolds = {
    'ā': 'a', 'á': 'a', 'â': 'a', 'ī': 'i', 'í': 'i', 'ū': 'u', 'ú': 'u',
    'ḥ': 'h', 'ṣ': 's', 'ḍ': 'd', 'ṭ': 't', 'ẓ': 'z', 'ḏ': 'dh', 'ṯ': 'th',
  };

  String _normalizeEnglish(String text) {
    var folded = text.toLowerCase();
    _latinFolds.forEach((from, to) => folded = folded.replaceAll(from, to));
    return folded.replaceAll(RegExp('[^a-z]'), '');
  }
}
