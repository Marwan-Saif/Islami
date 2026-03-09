
import 'package:islami/features/Radio/data/models/audio_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class AudioService {
  // نمط Singleton
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer audioPlayer = AudioPlayer();

  // جلب الـ ID الخاص بالملف الصوتي اللي شغال دلوقتي (من المشغل مباشرة)
  String? get currentPlayingId {
    final currentTag = audioPlayer.sequenceState?.currentSource?.tag;
    if (currentTag is MediaItem) {
      return currentTag.id;
    }
    return null;
  }

  // 1. دالة تشغيل ملف صوتي واحد
  Future<void> playSingle(AudioModel audio) async {
    // التحقق من المصدر الفعلي لمنع التقطيع لو ضغطنا على نفس الراديو
    if (currentPlayingId == audio.id && audioPlayer.playing) {
      return;
    }

    final mediaItem = MediaItem(
      id: audio.id,
      title: audio.title,
      artist: audio.subtitle,
      artUri: Uri.parse(audio.imageUrl),
    );

    final audioSource = AudioSource.uri(
      Uri.parse(audio.url),
      tag: mediaItem,
    );

    await audioPlayer.setAudioSource(audioSource);
    await audioPlayer.play();
  }

  // 2. دالة تشغيل قائمة صوتيات
  Future<void> playList(List<AudioModel> playlist, {int initialIndex = 0}) async {
    final List<AudioSource> audioSources = playlist.map((audio) {
      return AudioSource.uri(
        Uri.parse(audio.url),
        tag: MediaItem(
          id: audio.id,
          title: audio.title,
          artist: audio.subtitle,
          artUri: Uri.parse(audio.imageUrl),
        ),
      );
    }).toList();

    final concatenatingAudioSource = ConcatenatingAudioSource(
      useLazyPreparation: true,
      children: audioSources,
    );

    await audioPlayer.setAudioSource(
      concatenatingAudioSource,
      initialIndex: initialIndex,
      initialPosition: Duration.zero,
    );
    await audioPlayer.play();
  }

  // دوال التحكم
  Future<void> pauseAudio() async => await audioPlayer.pause();
  Future<void> stopAudio() async => await audioPlayer.stop();
}