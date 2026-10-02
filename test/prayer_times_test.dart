import 'package:flutter_test/flutter_test.dart';
import 'package:islami/features/Timer/data/prayer_times_service.dart';
import 'package:prayers_times/prayers_times.dart';

void main() {
  PrayerTimes cairoTimes(DateTime date, PrayerCalculationParameters params) =>
      PrayerTimes(
        coordinates: Coordinates(30.0444, 31.2357),
        calculationParameters: params,
        precision: true,
        locationName: 'Africa/Cairo',
        dateTime: date,
      );

  void expectClose(DateTime? actual, int hour, int minute) {
    final expected = DateTime(2026, 6, 20, hour, minute);
    final actualMinutes = actual!.hour * 60 + actual.minute;
    final expectedMinutes = expected.hour * 60 + expected.minute;
    expect((actualMinutes - expectedMinutes).abs(), lessThanOrEqualTo(2),
        reason: 'got ${actual.hour}:${actual.minute}, expected $hour:$minute');
  }

  test('matches the official cairo times (gate.ahram.org.eg, 20 june 2026)', () {
    final times = cairoTimes(
        DateTime(2026, 6, 20, 12), PrayerTimesService.calculationParameters());
    expectClose(times.fajrStartTime, 4, 8);
    expectClose(times.sunrise, 5, 54);
    expectClose(times.dhuhrStartTime, 12, 56);
    expectClose(times.asrStartTime, 16, 32);
    expectClose(times.maghribStartTime, 19, 59);
    expectClose(times.ishaStartTime, 21, 33);
  });

  test('asr is on the shafi madhab (earlier than hanafi)', () {
    final date = DateTime(2026, 10, 2, 12);
    final shafi = cairoTimes(date, PrayerTimesService.calculationParameters());
    final hanafi = cairoTimes(
        date, PrayerCalculationMethod.egyptian()..madhab = PrayerMadhab.hanafi);
    expect(shafi.asrStartTime!.isBefore(hanafi.asrStartTime!), isTrue);
  });
}
