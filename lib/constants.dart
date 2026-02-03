import 'package:islami/features/Timer/data/hive/zekr_localdata.dart';

String kLanguage = 'ar';
String kZekrBox = "zekr_box";
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
List<String> kFileNames = [
  'أذكار الصباح',
  'أذكار المساء',
  'أذكار الصلاة',
  'أذكار المسجد',
  'أذكار بعد الصلاة',
  'أذكار الاستيقاظ',
  'أذكار الطعام',
  'أذكار النوم',
];
List<ZekrLocalDataMoel> kAzkarData = [
  ZekrLocalDataMoel(
      zekrName: 'أذكار الصباح',
      zekrBody: 'لا تنسي أذكار الصباح',
      zekrtime: "07:00",
      zekrAllawed: true),
  ZekrLocalDataMoel(
      zekrName: 'أذكار المساء',
      zekrBody: "'لا تنسي أذكار المساء'",
      zekrtime: '19:00',
      zekrAllawed: true)
];
