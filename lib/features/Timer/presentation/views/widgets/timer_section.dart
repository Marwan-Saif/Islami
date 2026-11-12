import 'package:islami/core/utils/app_colors.dart';
import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:islami/core/widgets/brand/pattern_background.dart';
import 'package:islami/features/Timer/data/prayer_times_service.dart';
import 'package:islami/features/Timer/presentation/views/widgets/timer_card.dart';
import 'package:islami/generated/l10n.dart';
import 'package:intl/intl.dart' hide TextDirection;

class PrayerTimer extends StatefulWidget {
  const PrayerTimer({super.key});

  @override
  State<PrayerTimer> createState() => _PrayerTimerState();
}

class _PrayerTimerState extends State<PrayerTimer> {
  // الأسماء والتواريخ بتتعمل format في build عشان تتغير مع لغة التطبيق
  DayPrayerTimes? _today;
  // بعد العشاء الصلاة الجاية فجر بكرة، فبنحسب بكرة كمان عشان نعرض ميعاده الصح
  DayPrayerTimes? _tomorrow;
  DateTime? _todayDate;
  // كل حساب ليه رقم، والنتيجة بتتعرض بس لو مفيش حساب أحدث منها اتطلب
  int _request = 0;

  // الكارت اللي في النص هو الصلاة الجاية، وبيتحرك لوحده لما وقتها ييجي
  final CarouselSliderController _carousel = CarouselSliderController();
  int? _centeredIndex;
  Timer? _clock;

  @override
  void initState() {
    super.initState();
    _initializePrayerTimes();
    // الموقع بيتحدث مع فتح الأبلكيشن بعد ما الكارت يكون اتبنى
    PrayerTimesService.locationRevision.addListener(_initializePrayerTimes);
    _clock = Timer.periodic(const Duration(seconds: 30), (_) => _tick());
  }

  @override
  void dispose() {
    _clock?.cancel();
    PrayerTimesService.locationRevision.removeListener(_initializePrayerTimes);
    super.dispose();
  }

  // كل 30 ثانية: لو اليوم اتغير بنحسب مواقيت اليوم الجديد، ولو الصلاة الجاية
  // اتغيرت الكاروسيل بيتحرك عليها
  void _tick() {
    final today = _today;
    if (today == null || !mounted) return;
    final now = DateTime.now();
    if (!DateUtils.isSameDay(now, _todayDate)) {
      _initializePrayerTimes();
      return;
    }
    final next = _nextIndex(today, now);
    if (next != _centeredIndex) {
      _centeredIndex = next;
      _centerOn(next);
      setState(() {});
    }
  }

  // الـ controller مش بيشتغل غير بعد ما الكاروسيل يتبني، والمواقيت ممكن
  // تتحسب تاني قبلها (الموقع بيتحدث مع فتح الأبلكيشن)، فبنستنى لحد ما يجهز
  void _centerOn(int index) {
    if (_carousel.ready) {
      _carousel.animateToPage(index);
    } else {
      _carousel.onReady.then((_) {
        if (mounted) _carousel.animateToPage(index);
      });
    }
  }

  // بعد العشاء الصلاة الجاية فجر بكرة (تقريباً نفس وقت فجر النهارده)
  int _nextIndex(DayPrayerTimes today, DateTime now) =>
      today.nextIndex(now) ?? 0;

  Future<void> _updateLocation() async {
    final messenger = ScaffoldMessenger.of(context);
    final updated = await PrayerTimesService.updateLocation(request: true);
    if (updated) unawaited(PrayerNotifications.scheduleUpcoming());
    if (!mounted) return;
    setState(() {});
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          updated
              ? S.of(context).timesUpdatedForLocation
              : S.of(context).enableLocationForTimes,
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _initializePrayerTimes() async {
    // جدولة الأذان بقت في main عشان تشتغل حتى لو الشاشة دي متفتحتش
    final request = ++_request;
    final now = DateTime.now();
    final days = await PrayerTimesService.forDays(now, days: 2);
    // الموقع واليوم الجديد ممكن يطلبوا حساب في نفس الوقت، والأقدم ميكتبش فوق الأحدث
    if (!mounted || request != _request) return;
    final today = days.first;
    final next = _nextIndex(today, now);
    setState(() {
      _today = today;
      _tomorrow = days.length > 1 ? days[1] : null;
      _todayDate = now;
    });
    // أول مرة الكاروسيل بيتبني على الصلاة الجاية (initialPage)، وبعد كده
    // (تغيير الموقع أو يوم جديد) بيتحرك عليها
    if (_centeredIndex != null && _centeredIndex != next) {
      _centerOn(next);
    }
    _centeredIndex = next;
  }

  Future<void> _toggleAdhan() async {
    // بيتقرا من الإعدادات مش من متغير، عشان يفضل متزامن مع صفحة الإعدادات
    final adhanEnabled = !PrayerNotifications.isEnabled;
    await PrayerNotifications.setEnabled(adhanEnabled);
    if (!mounted) return;
    setState(() {});
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          adhanEnabled
              ? S.of(context).adhanTurnedOn
              : S.of(context).adhanTurnedOff,
        ),
        duration: const Duration(seconds: 2),
      ),
    );
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
    return _format('hh:mm', null, date);
  }

  @override
  Widget build(BuildContext context) {
    final today = _today;
    if (today == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final language = Localizations.localeOf(context).languageCode;
    final now = DateTime.now();
    final currentDay = _format('EEEE', language, now);
    // بعد العشاء الصلاة الجاية فجر بكرة: كارت الفجر والسطر اللي تحت بيعرضوا
    // ميعاد بكرة (كانوا بيعرضوا فجر النهارده اللي عدّى)
    final tomorrow = _tomorrow;
    final afterIsha = today.nextIndex(now) == null && tomorrow != null;
    DateTime wallTime(int i) =>
        afterIsha && i == 0 ? tomorrow.wallTime(0) : today.wallTime(i);
    final prayerTimesList = [
      for (int i = 0; i < DayPrayerTimes.names.length; i++)
        (
          _prayerName(DayPrayerTimes.names[i]),
          _formatDate(wallTime(i)),
          _format('a', language, wallTime(i)),
        ),
    ];
    final nextIndex = _nextIndex(today, now);
    final next = DayPrayerTimes.names[nextIndex];
    final nextTime = wallTime(nextIndex);
    final nextName = afterIsha
        ? '${_prayerName(next)} ${S.of(context).tomorrow}'
        : _prayerName(next);
    final city = PrayerTimesService.manualCity;
    final adhanEnabled = PrayerNotifications.isEnabled;
    return Container(
      margin: EdgeInsetsDirectional.symmetric(horizontal: 20.sp),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: IslamicPatternLayer(
              color: AppColors.onPrimary,
              opacity: 1.4,
            ),
          ),
          Column(
            children: [
              // الميلادي على الشمال والهجري على اليمين في اللغتين
              Row(
                textDirection: TextDirection.ltr,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _DateText(_gregorianDate(now, language))),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "${S.of(context).prayerTimes}\n$currentDay",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.amiri(
                        fontSize: 18.sp,
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(child: _DateText(_hijriDate(now, language))),
                ],
              ),
              const SizedBox(height: 20),

              // Prayer Times Carousel
              CarouselSlider.builder(
                carouselController: _carousel,
                itemBuilder: (context, index, realIndex) => PrayerTimerCard(
                  prayerName: prayerTimesList[index].$1,
                  time: prayerTimesList[index].$2,
                  isHighlighted: index == nextIndex,
                  pm: prayerTimesList[index].$3,
                ),
                itemCount: prayerTimesList.length,
                options: CarouselOptions(
                  height: 110.sp,
                  viewportFraction: 0.35,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.22,
                  initialPage: nextIndex,
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
                        : S
                              .of(context)
                              .timesForCity(
                                city?.name ?? S.of(context).defaultCityName,
                              ),
                    icon: Icon(
                      PrayerTimesService.usesDeviceLocation
                          ? Icons.location_on
                          : Icons.location_off,
                      color: AppColors.onPrimary,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      S
                          .of(context)
                          .nextPrayer(
                            nextName,
                            _format('hh:mm a', language, nextTime),
                          ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _toggleAdhan,
                    tooltip: adhanEnabled
                        ? S.of(context).disableAdhan
                        : S.of(context).enableAdhan,
                    icon: Icon(
                      adhanEnabled ? Icons.volume_up : Icons.volume_off,
                      color: AppColors.onPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _gregorianDate(DateTime now, String language) =>
      '${_format('d MMMM', language, now)}\n'
      '${_format('y', language, now)}';

  // تقويم أم القرى، بنفس الأرقام اللي في باقي التطبيق
  String _hijriDate(DateTime now, String language) {
    HijriCalendar.setLocal(language);
    final hijri = HijriCalendar.fromDate(now);
    return '${hijri.hDay} ${hijri.longMonthName}\n'
        '${hijri.hYear} ${language == 'ar' ? 'هـ' : 'AH'}';
  }

  /// الأرقام إنجليزي في كل الواجهة: DateFormat بالعربي بيطلّع أرقام عربية
  /// لوحده، فكان الكارت ده بس بأرقام مختلفة عن باقي التطبيق
  static String _format(String pattern, String? language, DateTime date) =>
      (DateFormat(pattern, language)..useNativeDigits = false).format(date);
}

class _DateText extends StatelessWidget {
  const _DateText(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.onPrimary,
          height: 1.3,
        ),
      ),
    );
  }
}
