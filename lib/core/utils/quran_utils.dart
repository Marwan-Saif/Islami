import 'package:quran_with_tafsir/quran_with_tafsir.dart';

/// اسم السورة للعرض، مثلاً "سورة الفاتحة"
String surahTitle(int surahNumber) =>
    'سورة ${QuranService.instance.getSurahNameArabic(surahNumber).trim()}';

/// "آية واحدة" / "آيتان" / "7 آيات" / "286 آية" حسب قواعد العدد في العربي
String ayahCountLabel(int count) {
  if (count == 1) return 'آية واحدة';
  if (count == 2) return 'آيتان';
  if (count >= 3 && count <= 10) return '$count آيات';
  return '$count آية';
}

// الباكدج بتحط في آخر كل آية رمز رقمها الخاص بخط مصحف الملك فهد
// (U+FC00 - U+FD1D)، وده بيطلع حرف غلط بخط Amiri، وإحنا بنرسم الرقم بنفسنا
final RegExp _ayahEndGlyph = RegExp('[  ]*[ﰀ-﴿]\\s*\$');

String cleanAyahText(String text) => text.replaceFirst(_ayahEndGlyph, '');
