import 'package:islami/features/Timer/data/hive/zekr_localdata.dart';
import 'package:islami/generated/l10n.dart';

String kLanguage = 'ar';
String kZekrBox = "zekr_box";
const String kOnboardingSeenKey = 'onboarding_seen';
const List<String> kFiles = [
  'assets/data/أذكار_الصباح.json',
  'assets/data/أذكار_المساء.json',
  'assets/data/أذكار_الصلاه.json',
  'assets/data/أذكار_المسجد.json',
  'assets/data/أذكار_بعد_الصلاة.json',
  'assets/data/أذكار_الاستيقاظ.json',
  'assets/data/أذكا_ الطعام.json',
  'assets/data/أذكار_النوم.json',
];
/// أسماء الأذكار بنفس ترتيب kFiles وبلغة التطبيق
/// (الـ widgets تبعت S.of(context) عشان تتبني تاني لما اللغة تتغير)
List<String> azkarNames(S s) => [
  s.azkarMorning,
  s.azkarEvening,
  s.azkarPrayer,
  s.azkarMosque,
  s.azkarAfterPrayer,
  s.azkarWakingUp,
  s.azkarFood,
  s.azkarSleep,
];

List<String> get kFileNames => azkarNames(S.current);
List<ZekrLocalDataMoel> kAzkarData = [
  ZekrLocalDataMoel(
      zekrName: 'أذكار الصباح',
      zekrBody: 'لا تنسَ أذكار الصباح',
      zekrtime: "07:00",
      zekrAllawed: true),
  ZekrLocalDataMoel(
      zekrName: 'أذكار المساء',
      zekrBody: 'لا تنسَ أذكار المساء',
      zekrtime: '19:00',
      zekrAllawed: true)
];
