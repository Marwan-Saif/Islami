import 'dart:isolate';

import 'package:islami/features/Quran/domain/quran_repo.dart';
import 'package:quran_with_tafsir/quran_with_tafsir.dart';

/// النص والتفسير والبيانات جايين من باكدج quran_with_tafsir كـ constants
/// جوه الأبلكيشن، فمفيش JSON بيتقرا أو بيتعمله parse وقت التشغيل
class QuranRepoImpl implements QuranRepo {
  final QuranService _quran = QuranService.instance;
  final Map<int, List<Ayah>> _ayahsCache = {};
  final Map<int, Map<int, String>> _tafsirCache = {};
  final Map<int, Map<int, String>> _translationCache = {};

  @override
  List<SurahMetadata> getSurahs() => _quran.getAllSurahs();

  @override
  List<Ayah> getAyahs(int surahNumber) => _ayahsCache.putIfAbsent(
    surahNumber,
    () => _quran.getVersesBySurah(surahNumber),
  );

  @override
  Map<int, String> getTafsir(int surahNumber) => _tafsirCache.putIfAbsent(
    surahNumber,
    () => _quran.getTafsir(surahNumber),
  );

  @override
  Map<int, String> getTranslation(int surahNumber) =>
      _translationCache.putIfAbsent(
        surahNumber,
        () => {
          for (final ayah in _quran.getVersesBySurah(
            surahNumber,
            language: QuranLanguage.english,
          ))
            ayah.id: ayah.text,
        },
      );

  @override
  Future<List<Ayah>> searchAyahs(String query, {int limit = 50}) {
    // أول بحث بيبني index لكل الآيات، فبيتعمل في isolate عشان الـ UI ميهنجش
    return Isolate.run(() => QuranService.instance.search(query, limit: limit));
  }
}
