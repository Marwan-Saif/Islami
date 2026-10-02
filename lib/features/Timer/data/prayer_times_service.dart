import 'dart:async';
import 'dart:developer';
import 'dart:isolate';

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
  static final Coordinates _defaultCoordinates = Coordinates(
    30.5657224,
    31.0168763,
  );
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
  static PrayerCalculationParameters calculationParameters() =>
      _parameters(method.key, isHanafi);

  static PrayerCalculationParameters _parameters(
    String methodKey,
    bool hanafi,
  ) {
    final option = kPrayerMethods.firstWhere(
      (m) => m.key == methodKey,
      orElse: () => kPrayerMethods.first,
    );
    final params = option.parameters();
    params.madhab = hanafi ? PrayerMadhab.hanafi : PrayerMadhab.shafi;
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
    unawaited(PrayerNotifications.scheduleUpcoming());
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
    return usesDeviceLocation
        ? NotificationHelper.location.name
        : _defaultTimeZone;
  }

  /// مواقيت [days] يوم من [start].
  /// مكتبة المواقيت بتعيد تحميل قاعدة بيانات المناطق الزمنية كلها مع كل يوم
  /// (عشرات الملي ثانية على الموبايل)، فالحساب بيتعمل في isolate عشان الـ UI ميقفش
  static Future<List<DayPrayerTimes>> forDays(DateTime start, {int days = 1}) {
    final coordinates = _coordinates;
    final latitude = coordinates.latitude;
    final longitude = coordinates.longitude;
    final methodKey = method.key;
    final hanafi = isHanafi;
    final timeZone = _timeZone;
    return Isolate.run(
      () => [
        for (int day = 0; day < days; day++)
          DayPrayerTimes._from(
            PrayerTimes(
              coordinates: Coordinates(latitude, longitude),
              calculationParameters: _parameters(methodKey, hanafi),
              precision: true,
              locationName: timeZone,
              dateTime: start.add(Duration(days: day)),
            ),
          ),
      ],
    );
  }

  static Future<void> _saveAndRefresh(String key, String value) async {
    await Prefs.saveData(key: key, value: value);
    locationRevision.value++;
    unawaited(PrayerNotifications.scheduleUpcoming());
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
/// مواقيت يوم واحد (الفجر، الشروق، الظهر، العصر، المغرب، العشاء)
class DayPrayerTimes {
  DayPrayerTimes._(this._instants, this._wallTimes);

  factory DayPrayerTimes._from(PrayerTimes times) {
    final all = [
      times.fajrStartTime!,
      times.sunrise!,
      times.dhuhrStartTime!,
      times.asrStartTime!,
      times.maghribStartTime!,
      times.ishaStartTime!,
    ];
    return DayPrayerTimes._(
      [
        for (final time in all)
          DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch),
      ],
      // TZDateTime مش بيتبعت بين الـ isolates، فبناخد الساعة بتوقيت المكان كـ DateTime عادي
      [
        for (final time in all)
          DateTime(time.year, time.month, time.day, time.hour, time.minute),
      ],
    );
  }

  static const List<String> names = [
    'fajr',
    'sunrise',
    'dhuhr',
    'asr',
    'maghrib',
    'isha',
  ];

  final List<DateTime> _instants;
  final List<DateTime> _wallTimes;

  /// الوقت المطلق (للإشعارات ولمعرفة الصلاة الجاية)
  DateTime instant(int index) => _instants[index];

  /// الساعة بتوقيت المكان نفسه للعرض
  DateTime wallTime(int index) => _wallTimes[index];

  /// ترتيب الصلوات الخمس (من غير الشروق) في القايمة
  static const List<int> prayerIndexes = [0, 2, 3, 4, 5];

  /// أول وقت لسه مجاش، أو null لو العشاء عدت
  int? nextIndex(DateTime now) {
    for (int i = 0; i < _instants.length; i++) {
      if (_instants[i].isAfter(now)) return i;
    }
    return null;
  }
}

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
    unawaited(scheduleUpcoming());
  }

  /// الفجر 0، الظهر 1، العصر 2، المغرب 3، العشاء 4
  static bool isPrayerEnabled(int prayer) =>
      Prefs.getData(key: _prayerKey(prayer)) ?? true;

  static Future<void> setPrayerEnabled(int prayer, bool enabled) async {
    await Prefs.saveData(key: _prayerKey(prayer), value: enabled);
    unawaited(scheduleUpcoming());
  }

  static int get reminderMinutes => Prefs.getData(key: _reminderKey) ?? 0;

  static Future<void> setReminderMinutes(int minutes) async {
    // الإعداد بيتحفظ على طول والجدولة بتكمل في الخلفية، عشان المفتاح
    // ميستناش جدولة ~50 إشعار قبل ما يتحرك
    await Prefs.saveData(key: _reminderKey, value: minutes);
    unawaited(scheduleUpcoming());
  }

  // الجدولة بتتنده من أكتر من مكان (فتح الأبلكيشن، الإعدادات، تحديث الموقع)،
  // فلو اتندهت مرتين ورا بعض كان ممكن الأقدم يخلص بعد الأحدث ويسيب إشعارات
  // بإعدادات قديمة. دلوقتي كل جدولة بتستنى اللي قبلها وبتقرا الإعدادات وقتها
  static Future<void> _queue = Future.value();

  static Future<void> scheduleUpcoming() {
    _queue = _queue.then((_) => _schedule()).catchError((Object e) {
      log('prayer notifications scheduling failed: $e');
    });
    return _queue;
  }

  static Future<void> _schedule() async {
    await Future.wait([
      for (int day = 0; day < _maxDaysAhead; day++)
        for (int prayer = 0; prayer < 5; prayer++) ...[
          NotificationHelper.cancelNotifications(_idFor(day, prayer)),
          NotificationHelper.cancelNotifications(_reminderIdFor(day, prayer)),
        ],
    ]);

    final reminder = reminderMinutes;
    // التذكير مستقل عن الأذان: لو المستخدم كتم الأذان أو قفله لصلاة معينة
    // التذكير بيفضل شغال (قبل كده كان بيقف معاه من غير ما يبان ليه)
    if (!isEnabled && reminder == 0) return;

    final arabic = AppSettings.instance.isArabic;
    final now = DateTime.now();
    final days = await PrayerTimesService.forDays(now, days: _daysAhead);
    for (int day = 0; day < days.length; day++) {
      for (int i = 0; i < DayPrayerTimes.prayerIndexes.length; i++) {
        final time = days[day].instant(DayPrayerTimes.prayerIndexes[i]);
        final name = prayerDisplayName(i);
        if (isEnabled && isPrayerEnabled(i)) {
          await NotificationHelper.scheduleAdhan(
            id: _idFor(day, i),
            title: arabic ? 'صلاة $name' : '$name prayer',
            body: arabic
                ? 'حان الآن موعد صلاة $name'
                : 'It is time for $name prayer',
            time: time,
          );
        }
        if (reminder > 0) {
          await NotificationHelper.schedulePrayerReminder(
            id: _reminderIdFor(day, i),
            title: arabic ? 'اقترب موعد صلاة $name' : '$name is coming up',
            body: arabic
                ? 'باقي ${_arabicMinutes(reminder)} على صلاة $name'
                : '$reminder minutes left until $name prayer',
            time: time.subtract(Duration(minutes: reminder)),
          );
        }
      }
    }
  }

  // 5 و 10 "دقائق"، 15 و 30 "دقيقة"
  static String _arabicMinutes(int minutes) =>
      minutes <= 10 ? '$minutes دقائق' : '$minutes دقيقة';
}
