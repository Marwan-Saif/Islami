import 'package:islami/core/services/app_settings.dart';
import 'package:islami/generated/l10n.dart';
import 'package:quran_with_tafsir/quran_with_tafsir.dart';

/// اسم السورة للعرض حسب لغة التطبيق، مثلاً "سورة الفاتحة" أو "Surah Al-Faatiha"
String surahTitle(int surahNumber) => AppSettings.instance.isArabic
    ? surahTitleArabic(surahNumber)
    : 'Surah ${QuranService.instance.getSurahNameEnglish(surahNumber).trim()}';

/// الاسم العربي دايماً، للأماكن اللي بتعرض الاسم بخط المصحف أو مع نص الآية
String surahTitleArabic(int surahNumber) =>
    'سورة ${QuranService.instance.getSurahNameArabic(surahNumber).trim()}';

/// "آية واحدة" / "آيتان" / "7 آيات" / "286 آية" حسب قواعد العدد في العربي
String ayahCountLabel(int count) => S.current.ayahCount(count);

// الباكدج بتحط في آخر كل آية رمز رقمها الخاص بخط مصحف الملك فهد
// (U+FC00 - U+FD1D)، وده بيطلع حرف غلط بخط Amiri، وإحنا بنرسم الرقم بنفسنا
final RegExp _ayahEndGlyph = RegExp('[\u00A0 ]*[\uFC00-\uFD3F]\\s*\$');

String cleanAyahText(String text) => text.replaceFirst(_ayahEndGlyph, '');
