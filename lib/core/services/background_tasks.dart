import 'dart:developer';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:islami/core/services/local_scheduled_notification.dart';
import 'package:islami/core/services/shared_prefs.dart';
import 'package:islami/features/Timer/data/prayer_times_service.dart';
import 'package:workmanager/workmanager.dart';

/// بيشتغل في isolate لوحده في الخلفية (من غير واجهة)، فلازم يهيّئ كل حاجة بنفسه
@pragma('vm:entry-point')
void backgroundTaskDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      DartPluginRegistrant.ensureInitialized();
      await Prefs.init();
      await NotificationHelper.init();
      await PrayerNotifications.scheduleUpcoming();
      return true;
    } catch (e) {
      log('background task $task failed: $e');
      return false;
    }
  });
}

/// تجديد جدولة الأذان في الخلفية.
///
/// الأذان بيتجدول لأسبوع قدام بس (iOS بيحتفظ بـ 64 إشعار، وأكتر من كده على
/// أندرويد بيعمل ANR)، فمن غير التجديد ده الأذان كان بيقف لو المستخدم مفتحش
/// الأبلكيشن أسبوع. أندرويد بيشغّل المهمة مرتين في اليوم تقريباً حتى لو
/// الأبلكيشن مقفول، وبيرجعها بعد restart الموبايل.
abstract class BackgroundTasks {
  static const String _rescheduleAdhan = 'reschedule-adhan';

  static Future<void> start() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await Workmanager().initialize(backgroundTaskDispatcher);
      await Workmanager().registerPeriodicTask(
        _rescheduleAdhan,
        _rescheduleAdhan,
        frequency: const Duration(hours: 12),
        // لو المهمة متسجلة من فتحة قبل كده بتفضل زي ما هي
        existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      );
    } catch (e) {
      log('could not register background tasks: $e');
    }
  }
}
