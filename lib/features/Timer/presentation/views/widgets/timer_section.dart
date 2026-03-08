import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/core/services/local_scheduled_notification.dart';
import 'package:islami/core/utils/app_images.dart';
import 'package:islami/features/Timer/presentation/views/widgets/timer_card.dart';
import 'package:prayers_times/prayers_times.dart';
import 'package:intl/intl.dart';

class PrayerTimer extends StatefulWidget {
  const PrayerTimer({super.key});

  @override
  State<PrayerTimer> createState() => _PrayerTimerState();
}

class _PrayerTimerState extends State<PrayerTimer> {
  List<List<dynamic>> prayerTimesList = [];
  String currentDay = DateFormat('EEEE', 'ar').format(DateTime.now());
  String currentDate = DateFormat.MMMEd('ar').format(DateTime.now());
  
  String nextPrayerName = '';
  String nextPrayerTimeFormatted = '';

  @override
  void initState() {
    super.initState();
    _initializePrayerTimes();
  }

  void _initializePrayerTimes() {
    Coordinates coordinates = Coordinates(30.5657224, 31.0168763);

    PrayerCalculationParameters params = PrayerCalculationMethod.karachi();
    params.madhab = PrayerMadhab.hanafi;

    PrayerTimes prayerTimes = PrayerTimes(
      coordinates: coordinates,
      calculationParameters: params,
      precision: true,
      locationName: "Africa/Cairo",
    );

    _addTimesToList(prayerTimes);
    _calculateNextPrayer(prayerTimes);
    _createNotification(prayerTimes);
  }

  void _addTimesToList(PrayerTimes prayerTimes) {
    prayerTimesList = [
      ['فجر', _formatDate(prayerTimes.fajrStartTime!), DateFormat('a', 'ar').format(prayerTimes.fajrStartTime!)],
      ['شروق', _formatDate(prayerTimes.sunrise!), DateFormat('a', 'ar').format(prayerTimes.sunrise!)],
      ['ظهر', _formatDate(prayerTimes.dhuhrStartTime!), DateFormat('a', 'ar').format(prayerTimes.dhuhrStartTime!)],
      ['عصر', _formatDate(prayerTimes.asrStartTime!), DateFormat('a', 'ar').format(prayerTimes.asrStartTime!)],
      ['مغرب', _formatDate(prayerTimes.maghribStartTime!), DateFormat('a', 'ar').format(prayerTimes.maghribStartTime!)],
      ['عشاء', _formatDate(prayerTimes.ishaStartTime!), DateFormat('a', 'ar').format(prayerTimes.ishaStartTime!)]
    ];
    setState(() {}); 
  }

  
  void _calculateNextPrayer(PrayerTimes prayerTimes) {
    String next = prayerTimes. nextPrayer(); 
    DateTime? nextTime = prayerTimes.timeForPrayer(next);
    
    
    Map<String, String> prayerNamesAr = {
      'fajr': 'الفجر', 'sunrise': 'الشروق', 'dhuhr': 'الظهر',
      'asr': 'العصر', 'maghrib': 'المغرب', 'isha': 'العشاء', 'none': 'الفجر'
    };

    if (nextTime != null) {
      setState(() {
        nextPrayerName = prayerNamesAr[next] ?? '';
        nextPrayerTimeFormatted = DateFormat('hh:mm a', 'en').format(nextTime);
      });
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('hh:mm').format(date); 
  }

  void _createNotification(PrayerTimes prayerTimes) {
    
    NotificationHelper.scheduleNotification('صلاة الفجر', 'حان الآن موعد صلاة الفجر', TimeOfDay.fromDateTime(prayerTimes.fajrStartTime!), 1);
    NotificationHelper.scheduleNotification('صلاة الظهر', 'حان الآن موعد صلاة الظهر', TimeOfDay.fromDateTime(prayerTimes.dhuhrStartTime!), 2);
    NotificationHelper.scheduleNotification('صلاة العصر', 'حان الآن موعد صلاة العصر', TimeOfDay.fromDateTime(prayerTimes.asrStartTime!), 3);
    NotificationHelper.scheduleNotification('صلاة المغرب', 'حان الآن موعد صلاة المغرب', TimeOfDay.fromDateTime(prayerTimes.maghribStartTime!), 4);
    NotificationHelper.scheduleNotification('صلاة العشاء', 'حان الآن موعد صلاة العشاء', TimeOfDay.fromDateTime(prayerTimes.ishaStartTime!), 5);
  }

  @override
  Widget build(BuildContext context) {
    
    if (prayerTimesList.isEmpty) {
      return const Center(child: CircularProgressIndicator()); 
    }

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
                  "مواقيت الصلاه\n$currentDay",
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
              prayerName: prayerTimesList[index][0],
              time: prayerTimesList[index][1],
              isHighlighted: true, // يفضل مستقبلاً وضع شرط لمعرفة الصلاة الحالية لتحديد الـ true/false
              pm: prayerTimesList[index][2],
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
              const SizedBox(width: 48), 
              Expanded(
                child: Text(
                  "Next: $nextPrayerName - $nextPrayerTimeFormatted", 
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.volume_off, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}