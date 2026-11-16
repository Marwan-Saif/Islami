import 'package:flutter_test/flutter_test.dart';
import 'package:islami/core/services/shared_prefs.dart';
import 'package:islami/features/Timer/data/prayer_times_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// الأذان بيتجدول تاني بس لو المستخدم بعد أكتر من 20 كم عن آخر جدولة
void main() {
  // آخر جدولة كانت في القاهرة
  const scheduled = {
    'adhan_scheduled_latitude': 30.0444,
    'adhan_scheduled_longitude': 31.2357,
  };

  Future<void> deviceAt(double latitude, double longitude) async {
    SharedPreferences.setMockInitialValues({
      ...scheduled,
      'prayer_latitude': latitude,
      'prayer_longitude': longitude,
    });
    await Prefs.init();
  }

  test('a move of about 10 km does not reschedule', () async {
    await deviceAt(30.0444 + 0.09, 31.2357); // ~10 كم شمال
    expect(PrayerNotifications.movedSinceLastSchedule(), isFalse);
  });

  test('a move of about 30 km reschedules', () async {
    await deviceAt(30.0444 + 0.27, 31.2357); // ~30 كم شمال
    expect(PrayerNotifications.movedSinceLastSchedule(), isTrue);
  });

  test('reschedules when nothing was scheduled before', () async {
    SharedPreferences.setMockInitialValues({
      'prayer_latitude': 30.0444,
      'prayer_longitude': 31.2357,
    });
    await Prefs.init();
    expect(PrayerNotifications.movedSinceLastSchedule(), isTrue);
  });
}
