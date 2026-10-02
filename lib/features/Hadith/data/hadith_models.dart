class HadithBook {
  const HadithBook({required this.key, required this.name, required this.sections});

  /// اسم الكتاب في hadith-api (bukhari, muslim, ...)
  final String key;
  final String name;
  final List<HadithSection> sections;
}

class HadithSection {
  const HadithSection(this.number, this.nameEn, this.firstHadith, this.lastHadith);
  final int number;

  /// المصدر فيه أسماء الأبواب بالإنجليزي بس
  final String nameEn;
  final int firstHadith;
  final int lastHadith;

  String get rangeLabel => firstHadith == lastHadith
      ? 'الحديث $firstHadith'
      : 'الأحاديث $firstHadith - $lastHadith';
}

class Hadith {
  const Hadith({required this.bookKey, required this.number, required this.text});
  final String bookKey;
  final num number;
  final String text;

  Map<String, dynamic> toJson() => {'book': bookKey, 'number': number, 'text': text};

  factory Hadith.fromJson(Map json) =>
      Hadith(bookKey: json['book'], number: json['number'], text: json['text']);
}
