import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami/core/utils/app_images.dart';
import 'package:islami/features/Timer/data/zekr_repo_impl.dart';
import 'package:islami/features/Timer/presentation/views/widgets/timer_section.dart';
import 'package:islami/features/Timer/presentation/views/widgets/zekr_section.dart';

class TimerView extends StatelessWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20.h), 
          
          Container(
            width: double.infinity,
            margin: EdgeInsetsDirectional.symmetric(horizontal: 60.w),
            child: Image.asset(
              Assets.imagesMosque001,
              height: 150.h,
              fit: BoxFit.cover, 
            ),
          ),
          
          SizedBox(height: 20.h),
          
          const PrayerTimer(),
          
          SizedBox(height: 20.h),
          
          Padding(
            padding: EdgeInsetsDirectional.only(end: 20.w), 
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                'الأذكار', 
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 18.sp, 
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SizedBox(height: 10.h),

          
          const ZekrListView(),

          
          SizedBox(height: 80.h), 
        ],
      ),
    );
  }
}