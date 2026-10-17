import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
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
    final currentTag = audioPlayer.sequenceState.currentSource?.tag;
    if (currentTag is MediaItem) {
      return currentTag.id;
    }
    return null;
  }

  // صورة الإشعار وشاشة القفل: أيقونة التطبيق من الـ assets. شريط الإشعارات
  // مش بيقرا الـ assets، فبتتنسخ مرة واحدة لملف في الـ cache.
  // (قبل كده كانت لينك لصورة Unsplash+ مدفوعة بتتنزل بعرض 2360 مع كل تشغيل)
  Future<Uri?>? _artUri;
  Future<Uri?> get _art => _artUri ??= _copyArt();

  static Future<Uri?> _copyArt() async {
    try {
      final file = File('${Directory.systemTemp.path}/islami_media_art.png');
      // بتتكتب مرة في كل تشغيلة (23KB) عشان لو الأيقونة اتغيرت في تحديث
      final data = await rootBundle.load('assets/images/app_icon.png');
      await file.writeAsBytes(data.buffer.asUint8List(), flush: true);
      return file.uri;
    } catch (e) {
      log('failed to prepare media art: $e');
      return null;
    }
  }

  MediaItem _mediaItem(AudioModel audio, Uri? art) => MediaItem(
    id: audio.id,
    title: audio.title,
    artist: audio.subtitle,
    artUri: art,
  );

  // 1. دالة تشغيل ملف صوتي واحد
  Future<void> playSingle(AudioModel audio) async {
    // التحقق من المصدر الفعلي لمنع التقطيع لو ضغطنا على نفس الراديو
    if (currentPlayingId == audio.id && audioPlayer.playing) {
      return;
    }

    final audioSource = AudioSource.uri(
      Uri.parse(audio.url),
      tag: _mediaItem(audio, await _art),
    );

    if (!await _load(() => audioPlayer.setAudioSource(audioSource))) return;
    await audioPlayer.play();
  }

  // 2. دالة تشغيل قائمة صوتيات
  Future<void> playList(
    List<AudioModel> playlist, {
    int initialIndex = 0,
  }) async {
    final art = await _art;
    final List<AudioSource> audioSources = [
      for (final audio in playlist)
        AudioSource.uri(Uri.parse(audio.url), tag: _mediaItem(audio, art)),
    ];

    final loaded = await _load(
      () => audioPlayer.setAudioSources(
        audioSources,
        initialIndex: initialIndex,
        initialPosition: Duration.zero,
      ),
    );
    if (!loaded) return;
    await audioPlayer.play();
  }

  // التحميل بيفشل لو النت فاصل، أو بيتقطع لو المستخدم شغّل حاجة تانية أو وقّف
  // قبل ما يخلص. الخطأ ده كان بيطلع من غير ما حد يمسكه
  Future<bool> _load(Future<Object?> Function() load) async {
    try {
      await load();
      return true;
    } on PlayerInterruptedException {
      return false;
    } catch (e) {
      log('failed to load audio: $e');
      return false;
    }
  }

  // دوال التحكم
  Future<void> pauseAudio() async => await audioPlayer.pause();
  Future<void> stopAudio() async => await audioPlayer.stop();
}
