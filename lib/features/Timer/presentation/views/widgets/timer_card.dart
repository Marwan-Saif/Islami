
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrayerTimerCard extends StatelessWidget {
  const PrayerTimerCard(
      {super.key,
      required this.prayerName,
      required this.time,
      required this.isHighlighted,
      required this.pm});
  final String prayerName, time, pm;
  final bool isHighlighted;
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 60,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF202020),
            const Color(0xFFB19768).withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            prayerName,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: isHighlighted ? Colors.white : Colors.black),
          ),
          const SizedBox(height: 2),
          // Text.rich(
          //   TextSpan(

          //     children: [
          //       TextSpan(
          //         text: time,
          //         style: TextStyle(
          //             fontSize: 14.sp,
          //             fontWeight: FontWeight.bold,
          //             color: isHighlighted ? Colors.white : Colors.black),
          //       ),
          //       TextSpan(
          //         text: " AM",
          //         style: TextStyle(
          //             fontSize: 14.sp,
          //             fontWeight: FontWeight.bold,
          //             color: isHighlighted ? Colors.white : Colors.black),
          //       ),
          //     ],
          // ))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              time,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                  color: isHighlighted ? Colors.white : Colors.black),
            ),
          ),
          Text(
            pm,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: isHighlighted ? Colors.white : Colors.black),
          ),
        ],
      ),
    );
  }
}
