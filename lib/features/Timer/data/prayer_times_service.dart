import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islami/core/services/local_scheduled_notification.dart';
import 'package:islami/core/services/shared_prefs.dart';
import 'package:prayers_times/prayers_times.dart';

/// مصدر واحد لمواقيت الصلاة عشان الكارت وإشعارات الأذان يطلعوا نفس الوقت
class PrayerTimesService {
  static const String _latitudeKey = 'prayer_latitude';
  static const String _longitudeKey = 'prayer_longitude';

  // الافتراضي (المنوفية) لحد ما المستخدم يسمح بالموقع
  static final Coordinates _defaultCoordinates =
      Coordinates(30.5657224, 31.0168763);
  static const String _defaultTimeZone = 'Africa/Cairo';

  /// بيزيد كل ما الموقع يتغير عشان كارت المواقيت يعيد الحساب
  static final ValueNotifier<int> locationRevision = ValueNotifier(0);

  static bool get usesDeviceLocation =>
      Prefs.getData(key: _latitudeKey) != null;

  static Coordinates get _coordinates {
    final double? latitude = Prefs.getData(key: _latitudeKey);
    final double? longitude = Prefs.getData(key: _longitudeKey);
    if (latitude == null || longitude == null) return _defaultCoordinates;
    return Coordinates(latitude, longitude);
  }

  // مواقيت موقع الجهاز بتتعرض بتوقيت الجهاز، والافتراضي بتوقيت القاهرة
  // (الإشعارات بتستخدم الوقت المطلق فمش بتتأثر بده)
  static String get _timeZone =>
      usesDeviceLocation ? NotificationHelper.location.name : _defaultTimeZone;

  /// طريقة الهيئة المصرية العامة للمساحة، والعصر على المذهب الشافعي
  /// (المكتبة بتخلي الحنفي هو الافتراضي فلازم نحدده)
  static PrayerCalculationParameters calculationParameters() {
    final params = PrayerCalculationMethod.egyptian();
    params.madhab = PrayerMadhab.shafi;
    return params;
  }

  static PrayerTimes forDate(DateTime date) {
    return PrayerTimes(
      coordinates: _coordinates,
      calculationParameters: calculationParameters(),
      precision: true,
      locationName: _timeZone,
      dateTime: date,
    );
  }

  /// بيحدث الموقع المتخزن من الـ GPS. من غير [request] مش بيطلب إذن
  /// (بيتنادى مع فتح الأبلكيشن)، ومعاه بيطلب الإذن (زرار الموقع في الكارت)
  static Future<bool> updateLocation({bool request = false}) async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return false;
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied && request) {
        permission = await Geolocator.requestPermission();
      }
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return false;
      }

      Position? position;
      try {
        // دقة المدينة كفاية للمواقيت
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low,
            timeLimit: Duration(seconds: 15),
          ),
        );
      } catch (e) {
        position = await Geolocator.getLastKnownPosition();
      }
      if (position == null) return false;

      await Prefs.saveData(key: _latitudeKey, value: position.latitude);
      await Prefs.saveData(key: _longitudeKey, value: position.longitude);
      locationRevision.value++;
      return true;
    } catch (e) {
      log('failed to update prayer location: $e');
      return false;
    }
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
