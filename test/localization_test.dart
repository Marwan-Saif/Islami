import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami/features/Hadith/data/hadith_books.dart';
import 'package:islami/generated/l10n.dart';

Map<String, dynamic> _arb(String language) =>
    jsonDecode(File('lib/l10n/intl_$language.arb').readAsStringSync());

void main() {
  test('arabic and english have the same keys and placeholders', () {
    final ar = _arb('ar');
    final en = _arb('en');
    expect(ar.keys.toSet(), en.keys.toSet());
    final placeholder = RegExp(r'\{(\w+)[,}]');
    for (final key in ar.keys) {
      Set<String> names(String text) =>
          placeholder.allMatches(text).map((m) => m.group(1)!).toSet();
      expect(names(ar[key]), names(en[key]), reason: key);
    }
  });

  test('arabic plurals follow the number rules', () async {
    final s = await S.load(const Locale('ar'));
    expect(s.ayahCount(1), 'آية واحدة');
    expect(s.ayahCount(2), 'آيتان');
    expect(s.ayahCount(7), '7 آيات');
    expect(s.ayahCount(286), '286 آية');
    expect(s.pagesCount(5), '5 صفحات');
    expect(s.pagesCount(20), '20 صفحة');
    expect(s.minutesCount(5), '5 دقائق');
    expect(s.minutesCount(15), '15 دقيقة');
  });

  test('english strings', () async {
    final s = await S.load(const Locale('en'));
    expect(s.ayahCount(1), '1 ayah');
    expect(s.ayahCount(286), '286 ayahs');
    expect(s.ayahRef('Surah Al-Baqara', 255), 'Surah Al-Baqara - Ayah 255');
    expect(kHadithBooks.first.sections.first.rangeLabel, 'Hadiths 1 - 7');
  });
}
