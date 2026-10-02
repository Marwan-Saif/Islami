import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static final _notification = FlutterLocalNotificationsPlugin();

  // من أندرويد 8 الصوت بيتثبت على الـ channel مش على الإشعار نفسه،
  // فعشان الأذان يبقى ليه صوت غير الأذكار لازم كل واحد ليه channel لوحده
  static const AndroidNotificationChannel _adhanChannel =
      AndroidNotificationChannel(
    'adhan_channel',
    'الأذان',
    description: 'إشعار دخول وقت الصلاة بصوت الأذان',
    importance: Importance.max,
    sound: RawResourceAndroidNotificationSound('azan'),
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
      await android.createNotificationChannel(_adhanChannel);
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

  /// إشعار الأذان في وقت الصلاة بالظبط (مرة واحدة)
  static Future<void> scheduleAdhan({
    required int id,
    required String title,
    required String body,
    required DateTime time,
  }) async {
    if (kIsWeb) return;
    final scheduledDate = tz.TZDateTime.from(time, location);
    if (!scheduledDate.isAfter(tz.TZDateTime.now(location))) return;

    await _notification.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _adhanChannel.id,
          _adhanChannel.name,
          channelDescription: _adhanChannel.description,
          importance: Importance.max,
          priority: Priority.high,
          sound: _adhanChannel.sound,
          category: AndroidNotificationCategory.alarm,
        ),
        iOS: const DarwinNotificationDetails(presentSound: true),
      ),
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
        iOS: const DarwinNotificationDetails(presentSound: true),
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
