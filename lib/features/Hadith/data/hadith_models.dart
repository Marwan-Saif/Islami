import 'package:islami/core/services/app_settings.dart';
import 'package:islami/generated/l10n.dart';

class HadithBook {
  const HadithBook({
    required this.key,
    required this.nameAr,
    required this.nameEn,
    required this.sections,
  });

  /// اسم الكتاب في hadith-api (bukhari, muslim, ...)
  final String key;
  final String nameAr;
  final String nameEn;
  final List<HadithSection> sections;

  String get name => AppSettings.instance.isArabic ? nameAr : nameEn;
}

class HadithSection {
  const HadithSection(this.number, this.nameEn, this.firstHadith, this.lastHadith);
  final int number;

  /// المصدر فيه أسماء الأبواب بالإنجليزي بس
  final String nameEn;
  final int firstHadith;
  final int lastHadith;

  String get rangeLabel => firstHadith == lastHadith
      ? S.current.hadithNumber(firstHadith)
      : S.current.hadithRange(firstHadith, lastHadith);
}

class Hadith {
  const Hadith({required this.bookKey, required this.number, required this.text});
  final String bookKey;
  final num number;
  final String text;

  // المفضلة ممكن يبقى فيها أحاديث بالعربي والإنجليزي مع بعض
  bool get isArabic =>
      RegExp('[؀-ۿ]').hasMatch(text.substring(0, text.length.clamp(0, 30)));

  Map<String, dynamic> toJson() => {'book': bookKey, 'number': number, 'text': text};

  factory Hadith.fromJson(Map json) =>
      Hadith(bookKey: json['book'], number: json['number'], text: json['text']);
}
