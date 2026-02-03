import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationHelper {
  static final _notification = FlutterLocalNotificationsPlugin();

  static init() async {
    await _notification.initialize(const InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/launcher_icon"),
    ));
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("Africa/Cairo"));
  }

  /// Schedule notification for a specific time of day
  static Future<void> scheduleNotification(
    String title,
    String body,
    TimeOfDay timeOfDay,
    int? id,
  ) async {
    // Get current time
    id = id ?? 1;
    final now = tz.TZDateTime.now(tz.local);
    log("scheduleNotificssation $now");
    // Calculate the next occurrence of the given time
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    // If the scheduled time has already passed today, schedule it for tomorrow

    scheduledDate = scheduledDate.subtract(const Duration(hours: 2));
    log("scheduleNotification $scheduledDate");
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    // Notification details
    var androidDetails = AndroidNotificationDetails(
      "important_notification",
      "My Channel",
      // id==8?"Default_Sound":"Default_Sound",
      sound: RawResourceAndroidNotificationSound(
          id == 3 ? "azan" : 'notification'),
      playSound: true,
// Place your sound file (e.g., my_sound.mp3) in the android/app/src/main/res/raw/ folder.
// If the raw folder does not exist, create it manually.
      importance: Importance.max,
      priority: Priority.high,
    );
    var notificationDetails = NotificationDetails(android: androidDetails);

    // Schedule the notification
    await _notification.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // payload: ''
    );
  }

  static cancelAllNotifications() {
    _notification.cancelAll();
  }

  static cancelNotifications(int id) {
    _notification.cancel(id);
  }
}
