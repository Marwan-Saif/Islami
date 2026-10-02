import 'package:flutter_test/flutter_test.dart';
import 'package:islami/core/utils/quran_utils.dart';
import 'package:islami/features/Quran/data/repo/quran_repo_impl.dart';
import 'package:islami/features/Quran/presentation/manager/quran_cubit/quran_cubit.dart';
import 'package:quran_with_tafsir/quran_with_tafsir.dart';

void main() {
  final repo = QuranRepoImpl();

  group('surah search (real package data)', () {
    late QuranCubit cubit;

    setUp(() => cubit = QuranCubit(repo)..getQuran());
    tearDown(() => cubit.close());

    List<int> numbers() =>
        (cubit.state as GetQuranSuccess).surahs.map((s) => s.number).toList();

    test('loads all 114 surahs', () => expect(numbers().length, 114));

    test('arabic search ignores tashkeel and the word surah', () {
      cubit.search('الكهف');
      expect(numbers(), [18]);
      cubit.search('سورة ال عمران');
      expect(numbers(), [3]);
    });

    test('english search ignores case, dashes and diacritics', () {
      cubit.search('fatiha');
      expect(numbers(), [1]);
      cubit.search('KAHF');
      expect(numbers(), [18]);
    });

    test('number search', () {
      cubit.search('18');
      expect(numbers(), [18]);
    });

    test('clearing the query shows all surahs', () {
      cubit.search('kahf');
      cubit.search('');
      expect(numbers().length, 114);
    });
  });

  group('quran text', () {
    test('ayah end glyphs are removed from every ayah', () {
      final glyph = RegExp('[ﰀ-﴿]');
      for (int surah = 1; surah <= 114; surah++) {
        for (final ayah in repo.getAyahs(surah)) {
          final text = cleanAyahText(ayah.text);
          expect(glyph.hasMatch(text), isFalse, reason: '$surah:${ayah.id}');
          expect(text.trim(), isNotEmpty);
        }
      }
    });

    test('al-baqara has 286 ayahs and tafsir for ayat al-kursi', () {
      expect(repo.getAyahs(2).length, 286);
      expect(repo.getTafsir(2)[255], isNotEmpty);
    });

    test('surah titles', () {
      expect(surahTitle(1), 'سورة الفَاتِحة');
      expect(QuranService.instance.getSurahMetadata(9).ayahCount, 129);
    });

    test('ayah search finds verses', () async {
      final results = await repo.searchAyahs('الحمد لله رب العالمين');
      expect(results.any((a) => a.surahNumber == 1 && a.id == 2), isTrue);
    });
  });
}
