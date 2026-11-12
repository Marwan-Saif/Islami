import 'package:islami/generated/l10n.dart';

class AudioModel {
  final String id;
  final String title;
  final String subtitle;
  final String url;

  AudioModel({
    required this.id,
    required this.title,
    required this.url,
    String? subtitle,
  }) : subtitle = subtitle ?? S.current.appSubtitle;
}
