import 'package:islami/core/utils/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrayerTimerCard extends StatelessWidget {
  const PrayerTimerCard({
    super.key,
    required this.prayerName,
    required this.time,
    required this.isHighlighted,
    required this.pm,
  });
  final String prayerName, time, pm;
  final bool isHighlighted;
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 60,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      // الصلاة الجاية كارت بلون الخلفية فوق الدهبي، والباقي شفاف
      decoration: BoxDecoration(
        color: isHighlighted
            ? AppColors.backgroundColor
            : AppColors.onPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.onPrimary.withValues(
            alpha: isHighlighted ? 0 : 0.18,
          ),
        ),
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 12,
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
                color: isHighlighted
                    ? AppColors.primaryColor
                    : AppColors.onPrimary.withValues(alpha: 0.85),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0.sp),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                time,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: isHighlighted
                      ? AppColors.primaryColor
                      : AppColors.onPrimary.withValues(alpha: 0.85),
                ),
              ),
            ),
          ),
          Text(
            pm,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: isHighlighted
                  ? AppColors.primaryColor
                  : AppColors.onPrimary.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}
