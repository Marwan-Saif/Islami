import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/core/services/local_scheduled_notification.dart';

import 'package:islami/core/utils/app_images.dart';
import 'package:islami/features/Timer/presentation/views/widgets/timer_card.dart';
import 'package:prayers_times/prayers_times.dart';
import 'package:intl/intl.dart';

class PrayerTimer extends StatelessWidget {
  PrayerTimer({
    super.key,
  });
  List<dynamic> prayerTimesList = [];
  String currentDay = DateFormat('EEEE', 'ar').format(DateTime.now());
  String currentDate = DateFormat.MMMEd('ar').format(DateTime.now());

  void getPrayerTimes() {
    Coordinates coordinates = Coordinates(30.5657224, 31.0168763);

    PrayerCalculationParameters params = PrayerCalculationMethod.karachi();
    params.madhab = PrayerMadhab.hanafi;

    PrayerTimes prayerTimes = PrayerTimes(
      coordinates: coordinates,
      calculationParameters: params,
      precision: true,
      locationName: "Africa/Cairo",
    );
    createNotification(prayerTimes);
    addTimes(prayerTimes);
  }

  void addTimes(PrayerTimes prayerTimes) {
    prayerTimesList.addAll(
      [
        [
          '  فجر  ',
          formteDate(prayerTimes.fajrStartTime!),
          DateFormat('a').format(prayerTimes.fajrStartTime!)
        ],
        [
          '  شروق  ',
          formteDate(prayerTimes.sunrise!),
          DateFormat('a').format(prayerTimes.sunrise!)
        ],
        [
          '  ظهر   ',
          formteDate(prayerTimes.dhuhrStartTime!),
          DateFormat('a').format(prayerTimes.dhuhrStartTime!)
        ],
        [
          '  عصر  ',
          formteDate(prayerTimes.asrStartTime!),
          DateFormat('a').format(prayerTimes.asrStartTime!)
        ],
        [
          '  مغرب  ',
          formteDate(prayerTimes.maghribStartTime!),
          DateFormat('a').format(prayerTimes.maghribStartTime!)
        ],
        [
          '  عشاء  ',
          formteDate(prayerTimes.ishaStartTime!),
          DateFormat('a').format(prayerTimes.ishaStartTime!)
        ]
      ],
    );

    print(prayerTimesList);
  }

  String formteDate(DateTime date) {
    return DateFormat('hh:mm ').format(date);
  }

  @override
  Widget build(BuildContext context) {
    getPrayerTimes();
    return Container(
      // width: 350,
      margin: EdgeInsetsDirectional.symmetric(horizontal: 20.sp),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        image: const DecorationImage(
            image: AssetImage(Assets.imagesTimerBackground), fit: BoxFit.fill),
        color: const Color(0xFF856b3e),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          // Top Row: Dates
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 70,
                child: Text("$currentDate",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              Text("مواقيت الصلاه\n $currentDay",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.amiri(
                    fontSize: 20.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(
                width: 70,
                child: Text("$currentDate",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Prayer Times
          CarouselSlider.builder(
            itemBuilder: (context, index, realIndex) => PrayerTimerCard(
              prayerName: prayerTimesList[index][0],
              time: prayerTimesList[index][1],
              isHighlighted: true,
              pm: prayerTimesList[index][2],
            ),
            itemCount: 6,
            options: CarouselOptions(
              height: 135.sp,
              viewportFraction: 0.35,
              enlargeCenterPage: true,
              enlargeFactor: 0.22,
              initialPage: 0,
              enableInfiniteScroll: true,
            ),
          ),
          const SizedBox(height: 20),

          //fotter
          Row(
            children: [
              const Spacer(),
              const Text("Next Pray - 02:32",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const Spacer(),
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

  void createNotification(PrayerTimes prayerTimes) {
    NotificationHelper.cancelNotifications(3);
    NotificationHelper.scheduleNotification('صلاة الفجر', 'موعد صلاة الفجر',
        TimeOfDay.fromDateTime(prayerTimes.fajrStartTime!), 3);
    NotificationHelper.scheduleNotification('صلاة الظهر', 'موعد صلاة الظهر',
        TimeOfDay.fromDateTime(prayerTimes.dhuhrStartTime!), 3);
    NotificationHelper.scheduleNotification('صلاة العصر', 'موعد صلاة العصر',
        TimeOfDay.fromDateTime(prayerTimes.asrStartTime!), 3);
    NotificationHelper.scheduleNotification('صلاة المغرب', 'موعد صلاة المغرب',
        TimeOfDay.fromDateTime(prayerTimes.maghribStartTime!), 3);
    NotificationHelper.scheduleNotification('صلاة العشاء', 'موعد صلاة العشاء',
        TimeOfDay.fromDateTime(prayerTimes.ishaStartTime!), 3);
  }
}
