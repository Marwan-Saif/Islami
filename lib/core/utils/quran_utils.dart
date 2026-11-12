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

/// علامة نهاية الآية "۝" ورقمها بالأرقام العربية جواها (زي المصحف).
/// خط Amiri بيرسم الرقم جوه الزخرفة لوحده. بتتكتب كنص عادي بدل WidgetSpan
/// لأن Flutter بيعكس ترتيب الـ WidgetSpans في السطر الواحد في النص العربي
/// (كان رقم 2 بيظهر قبل 1 في سورة الإخلاص)
String ayahEndMarker(int number) => '۝${arabicDigits(number.toString())}';

/// 0-9 → ٠-٩
String arabicDigits(String text) => text.replaceAllMapped(
  RegExp('[0-9]'),
  (m) => String.fromCharCode(0x0660 + int.parse(m[0]!)),
);
