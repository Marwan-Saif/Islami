import 'package:islami/features/Radio/data/models/audio_model.dart';
import 'package:islami/core/utils/quran_utils.dart';

class ReciterModel {
  final int id;
  final String name;
  final List<MoshafModel> moshaf;

  ReciterModel({required this.id, required this.name, required this.moshaf});

  factory ReciterModel.fromJson(Map<String, dynamic> json) {
    return ReciterModel(
      id: json['id'],
      name: json['name'],
      moshaf: [
        for (var item in json['moshaf'] as List) MoshafModel.fromJson(item),
      ],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'moshaf': [for (var item in moshaf) item.toJson()],
      };
}

/// المصحف = رواية معينة للقارئ (حفص، ورش، ...) وليها سيرفر وقائمة سور
class MoshafModel {
  final int id;
  final String name;
  final String server;
  final List<int> surahList;

  MoshafModel({
    required this.id,
    required this.name,
    required this.server,
    required this.surahList,
  });

  factory MoshafModel.fromJson(Map<String, dynamic> json) {
    final String surahs = json['surah_list'] ?? '';
    return MoshafModel(
      id: json['id'],
      name: json['name'],
      server: json['server'],
      surahList: [
        for (var number in surahs.split(','))
          if (int.tryParse(number.trim()) != null) int.parse(number.trim()),
      ],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'server': server,
        'surah_list': surahList.join(','),
      };

  // رابط السورة على سيرفرات mp3quran: server + 001.mp3
  String surahUrl(int surahNumber) =>
      '$server${surahNumber.toString().padLeft(3, '0')}.mp3';

  List<AudioModel> toPlaylist(ReciterModel reciter) => [
        for (var surah in surahList)
          AudioModel(
            id: audioId(reciter, surah),
            title: surahTitle(surah),
            subtitle: reciter.name,
            url: surahUrl(surah),
          ),
      ];

  String audioId(ReciterModel reciter, int surah) =>
      'recitation_${reciter.id}_${id}_$surah';
}
