import 'package:flutter_test/flutter_test.dart';
import 'package:islami/features/Radio/data/models/reciter_model.dart';
import 'package:islami/core/utils/quran_utils.dart';
import 'package:islami/features/Radio/domain/recitations_repo.dart';
import 'package:islami/features/Radio/presentation/manager/reciters_cubit/reciters_cubit.dart';

class _FakeRecitationsRepo implements RecitationsRepo {
  _FakeRecitationsRepo(this.reciters);
  final List<ReciterModel> reciters;

  @override
  Future<List<ReciterModel>> getReciters() async => reciters;

  @override
  ({ReciterModel reciter, MoshafModel moshaf}) getLastSelection() =>
      (reciter: reciters.first, moshaf: reciters.first.moshaf.first);

  @override
  Future<void> saveLastSelection(ReciterModel reciter, MoshafModel moshaf) async {}
}

ReciterModel _reciter(int id, String name) => ReciterModel.fromJson({
      'id': id,
      'name': name,
      'moshaf': [
        {
          'id': id,
          'name': 'حفص عن عاصم - مرتل',
          'server': 'https://server8.mp3quran.net/afs/',
          'surah_list': '1,2,114',
        }
      ],
    });

void main() {
  group('MoshafModel', () {
    test('parses surah list and builds mp3quran urls', () {
      final moshaf = _reciter(1, 'مشاري العفاسي').moshaf.first;
      expect(moshaf.surahList, [1, 2, 114]);
      expect(moshaf.surahUrl(1), 'https://server8.mp3quran.net/afs/001.mp3');
      expect(moshaf.surahUrl(114), 'https://server8.mp3quran.net/afs/114.mp3');
    });

    test('playlist uses surah names and the reciter as artist', () {
      final reciter = _reciter(1, 'مشاري العفاسي');
      final playlist = reciter.moshaf.first.toPlaylist(reciter);
      expect(playlist.map((audio) => audio.title),
          [surahTitle(1), surahTitle(2), surahTitle(114)]);
      expect(playlist.every((audio) => audio.subtitle == 'مشاري العفاسي'), isTrue);
    });

    test('survives a json round trip (used for the saved selection)', () {
      final reciter = _reciter(7, 'ماهر المعيقلي');
      final restored = ReciterModel.fromJson(reciter.toJson());
      expect(restored.name, reciter.name);
      expect(restored.moshaf.first.surahList, [1, 2, 114]);
    });
  });

  group('RecitersCubit.search', () {
    late RecitersCubit cubit;

    setUp(() async {
      cubit = RecitersCubit(_FakeRecitationsRepo([
        _reciter(1, 'عبدالباسط عبدالصمد'),
        _reciter(2, 'أحمد العجمي'),
        _reciter(3, 'ماهر المعيقلي'),
      ]));
      await cubit.getReciters();
    });

    tearDown(() => cubit.close());

    List<String> names() =>
        (cubit.state as RecitersSuccess).reciters.map((r) => r.name).toList();

    test('ignores spaces between names', () {
      cubit.search('عبد الباسط');
      expect(names(), ['عبدالباسط عبدالصمد']);
    });

    test('treats hamza forms the same', () {
      cubit.search('احمد');
      expect(names(), ['أحمد العجمي']);
    });

    test('empty query shows everyone', () {
      cubit.search('ماهر');
      cubit.search('');
      expect(names().length, 3);
    });
  });
}
