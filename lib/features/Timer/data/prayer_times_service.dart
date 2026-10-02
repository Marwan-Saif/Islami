import 'package:islami/core/services/local_scheduled_notification.dart';
import 'package:islami/core/services/shared_prefs.dart';
import 'package:prayers_times/prayers_times.dart';

/// مصدر واحد لمواقيت الصلاة عشان الكارت وإشعارات الأذان يطلعوا نفس الوقت
class PrayerTimesService {
  // الإحداثيات ثابتة على مصر، فالـ timezone لازم تبقى بتاعة نفس المكان
  // عشان المواقيت تتعرض بتوقيت المكان ده (الإشعارات بتستخدم الوقت المطلق فمش بتتأثر)
  static final Coordinates _coordinates = Coordinates(30.5657224, 31.0168763);
  static const String _timeZone = 'Africa/Cairo';

  static PrayerTimes forDate(DateTime date) {
    final params = PrayerCalculationMethod.karachi();
    params.madhab = PrayerMadhab.hanafi;
    return PrayerTimes(
      coordinates: _coordinates,
      calculationParameters: params,
      precision: true,
      locationName: _timeZone,
      dateTime: date,
    );
  }
}

/// بيجدول الأذان للأيام الجاية، لأن مواعيد الصلاة بتتغير كل يوم
/// فمينفعش إشعار واحد يتكرر يومياً في نفس الساعة
class PrayerNotifications {
  static const String _enabledKey = 'adhan_enabled';
  static const int _daysAhead = 7;

  // 100 + يوم * 10 + رقم الصلاة، بعيد عن IDs الأذكار
  static int _idFor(int day, int prayer) => 100 + day * 10 + prayer;

  static bool get isEnabled => Prefs.getData(key: _enabledKey) ?? true;

  static Future<void> setEnabled(bool enabled) async {
    await Prefs.saveData(key: _enabledKey, value: enabled);
    await scheduleUpcoming();
  }

  static Future<void> scheduleUpcoming() async {
    for (int day = 0; day < _daysAhead; day++) {
      for (int prayer = 0; prayer < 5; prayer++) {
        await NotificationHelper.cancelNotifications(_idFor(day, prayer));
      }
    }
    if (!isEnabled) return;

    final now = DateTime.now();
    for (int day = 0; day < _daysAhead; day++) {
      final times = PrayerTimesService.forDate(now.add(Duration(days: day)));
      final prayers = [
        ('الفجر', times.fajrStartTime),
        ('الظهر', times.dhuhrStartTime),
        ('العصر', times.asrStartTime),
        ('المغرب', times.maghribStartTime),
        ('العشاء', times.ishaStartTime),
      ];
      for (int i = 0; i < prayers.length; i++) {
        final (name, time) = prayers[i];
        if (time == null) continue;
        await NotificationHelper.scheduleAdhan(
          id: _idFor(day, i),
          title: 'صلاة $name',
          body: 'حان الآن موعد صلاة $name',
          time: time,
        );
      }
    }
  }
}
