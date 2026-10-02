import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:islami/core/helper_functions/app_router.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/utils/app_images.dart';
import 'package:islami/features/Hadith/presentation/views/widgets/hadith_books_section.dart';
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

          Stack(
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsetsDirectional.symmetric(horizontal: 60.w),
                child: Image.asset(
                  Assets.imagesMosque001,
                  height: 150.h,
                  fit: BoxFit.cover,
                ),
              ),
              PositionedDirectional(
                top: 8.h,
                end: 8.w,
                child: IconButton(
                  onPressed: () => context.push(AppRouter.settingsView),
                  tooltip: 'الإعدادات',
                  icon: Icon(
                    Icons.settings_rounded,
                    color: AppColors.primaryColor,
                    size: 28.r,
                  ),
                ),
              ),
            ],
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

          const HadithBooksSection(),

          SizedBox(height: 80.h),
        ],
      ),
    );
  }
}
