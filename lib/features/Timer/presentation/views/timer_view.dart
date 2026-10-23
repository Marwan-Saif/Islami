import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:islami/core/helper_functions/app_router.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/widgets/brand/brand_header.dart';
import 'package:islami/features/Hadith/presentation/views/widgets/hadith_books_section.dart';
import 'package:islami/features/Timer/presentation/views/widgets/timer_section.dart';
import 'package:islami/features/Timer/presentation/views/widgets/zekr_section.dart';
import 'package:islami/generated/l10n.dart';

class TimerView extends StatelessWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BrandHeader(
            trailing: IconButton(
              onPressed: () => context.push(AppRouter.settingsView),
              tooltip: S.of(context).settings,
              icon: Icon(
                Icons.settings_rounded,
                color: AppColors.primaryColor,
                size: 28.r,
              ),
            ),
          ),

          SizedBox(height: 12.h),

          const PrayerTimer(),

          SizedBox(height: 20.h),

          Padding(
            padding: EdgeInsetsDirectional.only(start: 20.w),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                S.of(context).azkar,
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SizedBox(height: 10.h),

          const ZekrListView(),

          const HadithBooksSection(),

          // مسافة الشريط العائم اللي تحت (extendBody)
          SizedBox(height: MediaQuery.paddingOf(context).bottom + 16.h),
        ],
      ),
    );
  }
}
