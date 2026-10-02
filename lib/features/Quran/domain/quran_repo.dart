import 'package:quran_with_tafsir/quran_with_tafsir.dart';

abstract class QuranRepo {
  List<SurahMetadata> getSurahs();

  List<Ayah> getAyahs(int surahNumber);

  /// التفسير الميسر لكل آيات السورة (رقم الآية -> التفسير)
  Map<int, String> getTafsir(int surahNumber);

  /// بحث في نص الآيات (بيتعامل مع التشكيل والهمزات)
  Future<List<Ayah>> searchAyahs(String query, {int limit = 50});
}
