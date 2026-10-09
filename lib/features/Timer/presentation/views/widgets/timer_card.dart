
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
      // الصلاة الجاية بإطار أبيض وظل، والباقي باهت شوية
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF202020),
            const Color(0xFFB19768).withValues(alpha: isHighlighted ? 0.85 : 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHighlighted ? Colors.white : Colors.transparent,
          width: 2,
        ),
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              prayerName,
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: isHighlighted ? Colors.white : Colors.white70),
            ),
          ),
          const SizedBox(height: 2),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 12.0.sp),
            child: FittedBox(
               fit: BoxFit.scaleDown,
              child: Text(
                time,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: isHighlighted ? Colors.white : Colors.white70),
              ),
            ),
          ),
          Text(
            pm,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: isHighlighted ? Colors.white : Colors.white70),
          ),
        ],
      ),
    );
  }
}
