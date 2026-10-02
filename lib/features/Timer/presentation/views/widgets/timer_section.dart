import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/core/utils/app_images.dart';
import 'package:islami/features/Timer/data/prayer_times_service.dart';
import 'package:islami/features/Timer/presentation/views/widgets/timer_card.dart';
import 'package:islami/generated/l10n.dart';
import 'package:intl/intl.dart';

class PrayerTimer extends StatefulWidget {
  const PrayerTimer({super.key});

  @override
  State<PrayerTimer> createState() => _PrayerTimerState();
}

class _PrayerTimerState extends State<PrayerTimer> {
  // الأسماء والتواريخ بتتعمل format في build عشان تتغير مع لغة التطبيق
  DayPrayerTimes? _today;
  bool adhanEnabled = PrayerNotifications.isEnabled;

  @override
  void initState() {
    super.initState();
    _initializePrayerTimes();
    // الموقع بيتحدث مع فتح الأبلكيشن بعد ما الكارت يكون اتبنى
    PrayerTimesService.locationRevision.addListener(_initializePrayerTimes);
  }

  @override
  void dispose() {
    PrayerTimesService.locationRevision.removeListener(_initializePrayerTimes);
    super.dispose();
  }

  Future<void> _updateLocation() async {
    final messenger = ScaffoldMessenger.of(context);
    final updated = await PrayerTimesService.updateLocation(request: true);
    if (updated) await PrayerNotifications.scheduleUpcoming();
    if (!mounted) return;
    setState(() {});
    messenger.showSnackBar(SnackBar(
      content: Text(updated
          ? S.of(context).timesUpdatedForLocation
          : S.of(context).enableLocationForTimes),
      duration: const Duration(seconds: 3),
    ));
  }

  Future<void> _initializePrayerTimes() async {
    // جدولة الأذان بقت في main عشان تشتغل حتى لو الشاشة دي متفتحتش
    final days = await PrayerTimesService.forDays(DateTime.now());
    if (mounted) setState(() => _today = days.first);
  }

  Future<void> _toggleAdhan() async {
    setState(() => adhanEnabled = !adhanEnabled);
    await PrayerNotifications.setEnabled(adhanEnabled);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(adhanEnabled
          ? S.of(context).adhanTurnedOn
          : S.of(context).adhanTurnedOff),
      duration: const Duration(seconds: 2),
    ));
  }

  String _prayerName(String prayer) {
    final s = S.of(context);
    return switch (prayer) {
      'sunrise' => s.sunrise,
      'dhuhr' => s.dhuhr,
      'asr' => s.asr,
      'maghrib' => s.maghrib,
      'isha' => s.isha,
      // بعد العشاء الصلاة الجاية فجر بكرة
      _ => s.fajr,
    };
  }

  String _formatDate(DateTime date) {
    return DateFormat('hh:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final today = _today;
    if (today == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final language = Localizations.localeOf(context).languageCode;
    final now = DateTime.now();
    final currentDay = DateFormat('EEEE', language).format(now);
    final currentDate = DateFormat.MMMEd(language).format(now);
    final prayerTimesList = [
      for (int i = 0; i < DayPrayerTimes.names.length; i++)
        (
          _prayerName(DayPrayerTimes.names[i]),
          _formatDate(today.wallTime(i)),
          DateFormat('a', language).format(today.wallTime(i)),
        ),
    ];
    // بعد العشاء الصلاة الجاية فجر بكرة (تقريباً نفس وقت فجر النهارده)
    final nextIndex = today.nextIndex(now) ?? 0;
    final next = DayPrayerTimes.names[nextIndex];
    final nextTime = today.wallTime(nextIndex);
    final city = PrayerTimesService.manualCity;
    return Container(
      margin: EdgeInsetsDirectional.symmetric(horizontal: 20.sp),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage(Assets.imagesTimerBackground), 
          fit: BoxFit.fill
        ),
        color: const Color(0xFF856b3e),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded( 
                child: Text(
                  currentDate,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "${S.of(context).prayerTimes}\n$currentDay",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.amiri(fontSize: 18.sp, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  currentDate,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Prayer Times Carousel
          CarouselSlider.builder(
            itemBuilder: (context, index, realIndex) => PrayerTimerCard(
              prayerName: prayerTimesList[index].$1,
              time: prayerTimesList[index].$2,
              isHighlighted: true, // يفضل مستقبلاً وضع شرط لمعرفة الصلاة الحالية لتحديد الـ true/false
              pm: prayerTimesList[index].$3,
            ),
            itemCount: prayerTimesList.length,
            options: CarouselOptions(
              height: 110.sp,
              viewportFraction: 0.35,
              enlargeCenterPage: true,
              enlargeFactor: 0.22,
              initialPage: 0,
              enableInfiniteScroll: true,
            ),
          ),
          const SizedBox(height: 20),

          
          Row(
            children: [
              IconButton(
                onPressed: _updateLocation,
                tooltip: PrayerTimesService.usesDeviceLocation
                    ? S.of(context).timesForMyLocation
                    : S.of(context).timesForCity(
                        city?.name ?? S.of(context).defaultCityName),
                icon: Icon(
                  PrayerTimesService.usesDeviceLocation
                      ? Icons.location_on
                      : Icons.location_off,
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: Text(
                  S.of(context).nextPrayer(
                    _prayerName(next),
                    DateFormat('hh:mm a', language).format(nextTime),
                  ), 
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              IconButton(
                onPressed: _toggleAdhan,
                tooltip: adhanEnabled
                    ? S.of(context).disableAdhan
                    : S.of(context).enableAdhan,
                icon: Icon(
                  adhanEnabled ? Icons.volume_up : Icons.volume_off,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}