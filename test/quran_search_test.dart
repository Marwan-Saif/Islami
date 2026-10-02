import 'package:flutter_test/flutter_test.dart';
import 'package:islami/features/Quran/data/models/surah_model.dart';
import 'package:islami/features/Quran/domain/quran_repo.dart';
import 'package:islami/features/Quran/presentation/manager/quran_cubit/quran_cubit.dart';

class _FakeQuranRepo implements QuranRepo {
  @override
  Future<QuranModel> getQuranData() async => QuranModel(data: [
        // نفس شكل الأسماء في assets/data/quran.json (متشكلة)
        SurahModel(number: 1, name: 'سُورَةُ الْفَاتِحَةِ', englishName: 'Al-Faatiha'),
        SurahModel(number: 3, name: 'سُورَةُ آلِ عِمۡرَانَ', englishName: 'Aal-i-Imraan'),
        SurahModel(number: 18, name: 'سُورَةُ الكَهۡفِ', englishName: 'Al-Kahf'),
      ]);
}

void main() {
  late QuranCubit cubit;

  setUp(() async {
    cubit = QuranCubit(_FakeQuranRepo())..getQuran();
    await Future<void>.delayed(Duration.zero);
  });

  tearDown(() => cubit.close());

  List<int?> numbers() =>
      (cubit.state as GetQuranSuccess).quranModel.data!.map((s) => s.number).toList();

  test('arabic search ignores tashkeel', () {
    cubit.search('الكهف');
    expect(numbers(), [18]);
  });

  test('arabic search ignores the word surah and alef forms', () {
    cubit.search('سورة ال عمران');
    expect(numbers(), [3]);
    cubit.search('آل عمران');
    expect(numbers(), [3]);
  });

  test('english search ignores case and dashes', () {
    cubit.search('alfaatiha');
    expect(numbers(), [1]);
  });

  test('number search', () {
    cubit.search('18');
    expect(numbers(), [18]);
  });

  test('clearing the query shows all surahs', () {
    cubit.search('kahf');
    cubit.search('');
    expect(numbers(), [1, 3, 18]);
  });
}
