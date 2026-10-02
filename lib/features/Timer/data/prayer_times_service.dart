import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islami/core/services/app_settings.dart';
import 'package:islami/core/services/local_scheduled_notification.dart';
import 'package:islami/core/services/shared_prefs.dart';
import 'package:islami/features/Timer/data/prayer_settings_data.dart';
import 'package:prayers_times/prayers_times.dart';

/// مصدر واحد لمواقيت الصلاة عشان الكارت وإشعارات الأذان يطلعوا نفس الوقت
class PrayerTimesService {
  static const String _latitudeKey = 'prayer_latitude';
  static const String _longitudeKey = 'prayer_longitude';
  static const String _methodKey = 'prayer_method';
  static const String _madhabKey = 'prayer_madhab';
  static const String _cityKey = 'prayer_city';

  // الافتراضي (المنوفية) لحد ما المستخدم يسمح بالموقع أو يختار مدينة
  static final Coordinates _defaultCoordinates =
      Coordinates(30.5657224, 31.0168763);
  static const String _defaultTimeZone = 'Africa/Cairo';

  /// بيزيد مع أي تغيير في الموقع أو طريقة الحساب عشان كارت المواقيت يعيد الحساب
  static final ValueNotifier<int> locationRevision = ValueNotifier(0);

  // ---------- طريقة الحساب ----------
  static PrayerMethodOption get method => kPrayerMethods.firstWhere(
        (m) => m.key == Prefs.getData(key: _methodKey),
        orElse: () => kPrayerMethods.first,
      );

  static bool get isHanafi => Prefs.getData(key: _madhabKey) == 'hanafi';

  static Future<void> setMethod(PrayerMethodOption option) =>
      _saveAndRefresh(_methodKey, option.key);

  static Future<void> setHanafi(bool hanafi) =>
      _saveAndRefresh(_madhabKey, hanafi ? 'hanafi' : 'shafi');

  /// الطريقة المختارة (الافتراضي الهيئة المصرية) والمذهب (الافتراضي الشافعي،
  /// والمكتبة بتخلي الحنفي هو الافتراضي فلازم نحدده)
  static PrayerCalculationParameters calculationParameters() {
    final params = method.parameters();
    params.madhab = isHanafi ? PrayerMadhab.hanafi : PrayerMadhab.shafi;
    return params;
  }

  // ---------- الموقع ----------
  /// المدينة اللي المستخدم اختارها يدوي، أو null لو الموقع تلقائي
  static PrayerCity? get manualCity {
    final key = Prefs.getData(key: _cityKey);
    if (key == null) return null;
    return kPrayerCities.where((city) => city.key == key).firstOrNull;
  }

  static Future<void> setManualCity(PrayerCity? city) async {
    city == null
        ? await Prefs.removeData(key: _cityKey)
        : await Prefs.saveData(key: _cityKey, value: city.key);
    locationRevision.value++;
    await PrayerNotifications.scheduleUpcoming();
  }

  static bool get usesDeviceLocation =>
      manualCity == null && Prefs.getData(key: _latitudeKey) != null;

  static Coordinates get _coordinates {
    final city = manualCity;
    if (city != null) return Coordinates(city.latitude, city.longitude);
    final double? latitude = Prefs.getData(key: _latitudeKey);
    final double? longitude = Prefs.getData(key: _longitudeKey);
    if (latitude == null || longitude == null) return _defaultCoordinates;
    return Coordinates(latitude, longitude);
  }

  // المواقيت بتتعرض بتوقيت المكان نفسه (الإشعارات بتستخدم الوقت المطلق)
  static String get _timeZone {
    final city = manualCity;
    if (city != null) return city.timeZone;
    return usesDeviceLocation ? NotificationHelper.location.name : _defaultTimeZone;
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

  static Future<void> _saveAndRefresh(String key, String value) async {
    await Prefs.saveData(key: key, value: value);
    locationRevision.value++;
    await PrayerNotifications.scheduleUpcoming();
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
      // لو المستخدم طلب موقعه الحالي يبقى مش عايز المدينة اليدوي
      if (request) await Prefs.removeData(key: _cityKey);
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
  static const String _reminderKey = 'adhan_reminder_minutes';
  static String _prayerKey(int prayer) => 'adhan_prayer_$prayer';

  static const List<int> reminderOptions = [0, 5, 10, 15, 30];

  // iOS بيحتفظ بـ 64 إشعار بس، فلما التذكير شغال (إشعارين لكل صلاة) بنجدول أيام أقل
  static int get _daysAhead => reminderMinutes > 0 ? 5 : 7;
  static const int _maxDaysAhead = 7;

  // 100 + يوم * 10 + رقم الصلاة للأذان، و 200 + ... للتذكير
  static int _idFor(int day, int prayer) => 100 + day * 10 + prayer;
  static int _reminderIdFor(int day, int prayer) => 200 + day * 10 + prayer;

  /// المفتاح الرئيسي (زرار الكتم في كارت المواقيت)
  static bool get isEnabled => Prefs.getData(key: _enabledKey) ?? true;

  static Future<void> setEnabled(bool enabled) async {
    await Prefs.saveData(key: _enabledKey, value: enabled);
    await scheduleUpcoming();
  }

  /// الفجر 0، الظهر 1، العصر 2، المغرب 3، العشاء 4
  static bool isPrayerEnabled(int prayer) =>
      Prefs.getData(key: _prayerKey(prayer)) ?? true;

  static Future<void> setPrayerEnabled(int prayer, bool enabled) async {
    await Prefs.saveData(key: _prayerKey(prayer), value: enabled);
    await scheduleUpcoming();
  }

  static int get reminderMinutes => Prefs.getData(key: _reminderKey) ?? 0;

  static Future<void> setReminderMinutes(int minutes) async {
    await Prefs.saveData(key: _reminderKey, value: minutes);
    await scheduleUpcoming();
  }

  static Future<void> scheduleUpcoming() async {
    for (int day = 0; day < _maxDaysAhead; day++) {
      for (int prayer = 0; prayer < 5; prayer++) {
        await NotificationHelper.cancelNotifications(_idFor(day, prayer));
        await NotificationHelper.cancelNotifications(_reminderIdFor(day, prayer));
      }
    }
    if (!isEnabled) return;

    final arabic = AppSettings.instance.isArabic;
    final reminder = reminderMinutes;
    final now = DateTime.now();
    for (int day = 0; day < _daysAhead; day++) {
      final times = PrayerTimesService.forDate(now.add(Duration(days: day)));
      final prayerTimes = [
        times.fajrStartTime,
        times.dhuhrStartTime,
        times.asrStartTime,
        times.maghribStartTime,
        times.ishaStartTime,
      ];
      for (int i = 0; i < prayerTimes.length; i++) {
        final time = prayerTimes[i];
        if (time == null || !isPrayerEnabled(i)) continue;
        final name = arabic ? kPrayerNamesAr[i] : kPrayerNamesEn[i];
        await NotificationHelper.scheduleAdhan(
          id: _idFor(day, i),
          title: arabic ? 'صلاة $name' : '$name prayer',
          body: arabic ? 'حان الآن موعد صلاة $name' : 'It is time for $name prayer',
          time: time,
        );
        if (reminder > 0) {
          await NotificationHelper.schedulePrayerReminder(
            id: _reminderIdFor(day, i),
            title: arabic ? 'اقترب موعد صلاة $name' : '$name is coming up',
            body: arabic
                ? 'باقي $reminder دقيقة على صلاة $name'
                : '$reminder minutes left until $name prayer',
            time: time.subtract(Duration(minutes: reminder)),
          );
        }
      }
    }
  }
}
