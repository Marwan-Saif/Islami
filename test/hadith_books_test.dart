import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami/features/Hadith/data/hadith_books.dart';
import 'package:islami/generated/l10n.dart';

void main() {
  setUpAll(() => S.load(const Locale('ar')));

  test('the nine books are in the index', () {
    expect(kHadithBooks.map((b) => b.key), [
      'bukhari', 'muslim', 'abudawud', 'tirmidhi', 'nasai', 'ibnmajah',
      'malik', 'nawawi', 'qudsi',
    ]);
  });

  test('sections have valid, increasing hadith ranges', () {
    for (final book in kHadithBooks) {
      expect(book.sections, isNotEmpty, reason: book.key);
      for (final section in book.sections) {
        expect(section.firstHadith, lessThanOrEqualTo(section.lastHadith),
            reason: '${book.key} ${section.number}');
      }
      final numbers = book.sections.map((s) => s.number).toList();
      expect(numbers.toSet().length, numbers.length, reason: '${book.key} duplicates');
    }
  });

  test('bukhari starts with revelation (hadith 1 - 7)', () {
    final first = kHadithBooks.first.sections.first;
    expect(first.nameEn, 'Revelation');
    expect(first.rangeLabel, 'الأحاديث 1 - 7');
  });
}
