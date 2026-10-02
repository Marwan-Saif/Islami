import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:islami/constants.dart';
import 'package:islami/core/services/local_scheduled_notification.dart';
import 'package:islami/features/Timer/data/hive/zekr_localdata.dart';

class AzkarNotifications {
  // 10 + ترتيب الذكر، عشان ميتلخبطش مع IDs الأذان
  static int _idFor(int index) => 10 + index;

  /// بيجدول تذكير الأذكار من الإعدادات المتخزنة، وبيتنادى مع فتح الأبلكيشن
  /// عشان التذكير يفضل شغال حتى لو المستخدم مفتحش شاشة الأذكار
  static Future<void> scheduleFromStorage() async {
    final box = Hive.box<ZekrLocalDataMoel>(kZekrBox);
    if (box.isEmpty) {
      await box.addAll(kAzkarData);
    }
    await schedule(box.values.toList());
  }

  static Future<void> schedule(List<ZekrLocalDataMoel> azkar) async {
    for (int i = 0; i < azkar.length; i++) {
      final zekr = azkar[i];
      // لازم نلغي الأول عشان لو المستخدم قفل التذكير ميفضلش شغال
      await NotificationHelper.cancelNotifications(_idFor(i));
      if (!zekr.zekrAllawed) continue;
      await NotificationHelper.scheduleDailyZekr(
        id: _idFor(i),
        title: zekr.zekrName,
        body: zekr.zekrBody,
        time: parseTimeOfDay(zekr.zekrtime),
      );
    }
  }

  static TimeOfDay parseTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
