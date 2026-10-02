import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:islami/core/services/app_settings.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static final _notification = FlutterLocalNotificationsPlugin();

  // من أندرويد 8 الصوت بيتثبت على الـ channel مش على الإشعار نفسه،
  // فكل صوت أذان (وصوت الأذكار) ليه channel لوحده
  static const Map<AdhanSound, AndroidNotificationChannel> _adhanChannels = {
    AdhanSound.full: AndroidNotificationChannel(
      'adhan_channel',
      'الأذان',
      description: 'إشعار دخول وقت الصلاة بصوت الأذان كاملاً',
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('azan'),
    ),
    AdhanSound.short: AndroidNotificationChannel(
      'adhan_short_channel',
      'الأذان (مختصر)',
      description: 'إشعار دخول وقت الصلاة بأول الأذان',
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('azan_short'),
    ),
    AdhanSound.tone: AndroidNotificationChannel(
      'adhan_tone_channel',
      'الأذان (تنبيه قصير)',
      description: 'إشعار دخول وقت الصلاة بصوت تنبيه قصير',
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('notification'),
    ),
    AdhanSound.silent: AndroidNotificationChannel(
      'adhan_silent_channel',
      'الأذان (صامت)',
      description: 'إشعار دخول وقت الصلاة من غير صوت',
      importance: Importance.high,
      playSound: false,
    ),
  };
  static const AndroidNotificationChannel _reminderChannel =
      AndroidNotificationChannel(
    'prayer_reminder_channel',
    'التذكير قبل الصلاة',
    description: 'تذكير قبل دخول وقت الصلاة',
    importance: Importance.high,
    sound: RawResourceAndroidNotificationSound('notification'),
  );
  static const AndroidNotificationChannel _azkarChannel =
      AndroidNotificationChannel(
    'azkar_channel',
    'الأذكار',
    description: 'تذكير بأذكار الصباح والمساء',
    importance: Importance.high,
    sound: RawResourceAndroidNotificationSound('notification'),
  );

  // الـ channel القديمة كانت بصوت واحد لكل الإشعارات
  static const String _legacyChannelId = 'important_notification';

  // مش بنعتمد على tz.local لأن مكتبة prayers_times بتعمل initializeTimeZones
  // جوه الـ constructor وده بيرجع tz.local لـ UTC
  static tz.Location? _location;
  static tz.Location get location => _location ?? tz.getLocation('Africa/Cairo');

  static Future<void> init() async {
    // flutter_local_notifications مش بتدعم الويب
    if (kIsWeb) return;
    tz.initializeTimeZones();
    _location = await _deviceLocation();
    tz.setLocalLocation(location);

    await _notification.initialize(const InitializationSettings(
      android: AndroidInitializationSettings('ic_notification'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    ));

    final android = _androidPlugin;
    if (android != null) {
      await android.deleteNotificationChannel(_legacyChannelId);
      for (final channel in _adhanChannels.values) {
        await android.createNotificationChannel(channel);
      }
      await android.createNotificationChannel(_reminderChannel);
      await android.createNotificationChannel(_azkarChannel);
    }
  }

  static Future<tz.Location> _deviceLocation() async {
    try {
      final timezone = await FlutterTimezone.getLocalTimezone();
      return tz.getLocation(timezone.identifier);
    } catch (e) {
      log('could not get device timezone, falling back to Africa/Cairo: $e');
      return tz.getLocation('Africa/Cairo');
    }
  }

  static AndroidFlutterLocalNotificationsPlugin? get _androidPlugin =>
      _notification.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  /// أندرويد 13+ و iOS لازم المستخدم يوافق على الإشعارات الأول
  static Future<void> requestPermissions() async {
    if (kIsWeb) return;
    await _androidPlugin?.requestNotificationsPermission();
    await _notification
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  // لو إذن الـ exact alarm مش متاح بنجدول inexact بدل ما الجدولة تفشل
  static Future<AndroidScheduleMode> _scheduleMode() async {
    final canScheduleExact =
        await _androidPlugin?.canScheduleExactNotifications() ?? true;
    return canScheduleExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;
  }

  /// إشعار الأذان في وقت الصلاة بالظبط (مرة واحدة) بالصوت المختار في الإعدادات
  static Future<void> scheduleAdhan({
    required int id,
    required String title,
    required String body,
    required DateTime time,
  }) async {
    final sound = AppSettings.instance.adhanSound;
    final channel = _adhanChannels[sound]!;
    await _scheduleOnce(
      id: id,
      title: title,
      body: body,
      time: time,
      details: NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: channel.importance,
          priority: Priority.high,
          playSound: channel.playSound,
          sound: channel.sound,
          category: AndroidNotificationCategory.alarm,
        ),
        // iOS مش بيشغل mp3 ولا أصوات أطول من 30 ثانية، فـ ios/Runner/azan.wav
        // نسخة wav من أول 29 ثانية من الأذان (للكامل والمختصر)
        iOS: DarwinNotificationDetails(
          presentSound: sound != AdhanSound.silent,
          sound: switch (sound) {
            AdhanSound.full || AdhanSound.short => 'azan.wav',
            AdhanSound.tone => 'notification.wav',
            AdhanSound.silent => null,
          },
        ),
      ),
    );
  }

  /// تذكير قبل الصلاة بعدد دقائق (بصوت تنبيه قصير)
  static Future<void> schedulePrayerReminder({
    required int id,
    required String title,
    required String body,
    required DateTime time,
  }) {
    return _scheduleOnce(
      id: id,
      title: title,
      body: body,
      time: time,
      details: NotificationDetails(
        android: AndroidNotificationDetails(
          _reminderChannel.id,
          _reminderChannel.name,
          channelDescription: _reminderChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          sound: _reminderChannel.sound,
        ),
        iOS: const DarwinNotificationDetails(
          presentSound: true,
          sound: 'notification.wav',
        ),
      ),
    );
  }

  static Future<void> _scheduleOnce({
    required int id,
    required String title,
    required String body,
    required DateTime time,
    required NotificationDetails details,
  }) async {
    if (kIsWeb) return;
    final scheduledDate = tz.TZDateTime.from(time, location);
    if (!scheduledDate.isAfter(tz.TZDateTime.now(location))) return;
    await _notification.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: await _scheduleMode(),
    );
  }

  /// تذكير بيتكرر كل يوم في نفس الساعة
  static Future<void> scheduleDailyZekr({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
  }) async {
    if (kIsWeb) return;
    final now = tz.TZDateTime.now(location);
    var scheduledDate = tz.TZDateTime(
        location, now.year, now.month, now.day, time.hour, time.minute);
    // لو الوقت عدى النهارده يبدأ من بكرة
    if (!scheduledDate.isAfter(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notification.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _azkarChannel.id,
          _azkarChannel.name,
          channelDescription: _azkarChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          sound: _azkarChannel.sound,
        ),
        iOS: const DarwinNotificationDetails(
          presentSound: true,
          sound: 'notification.wav',
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: await _scheduleMode(),
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> cancelAllNotifications() async {
    if (kIsWeb) return;
    await _notification.cancelAll();
  }

  static Future<void> cancelNotifications(int id) async {
    if (kIsWeb) return;
    await _notification.cancel(id);
  }
}
