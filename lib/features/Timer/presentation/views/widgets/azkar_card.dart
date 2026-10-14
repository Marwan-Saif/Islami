import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/core/helper_functions/app_router.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/features/Timer/domain/zekr_entity.dart';
import 'package:islami/generated/l10n.dart';

class AZkarCard extends StatelessWidget {
  const AZkarCard({super.key, required this.zekr});
  final ZekrEntity zekr;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRouter.suoraSCreen, extra: zekr),
      child: Container(
        constraints: BoxConstraints(maxWidth: 320.sp),
        padding: const EdgeInsetsDirectional.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.primaryColor, width: 2.0),
        ),
        child: Column(
          children: [
            Text(
              zekr.hint,
              style: GoogleFonts.amiri(
                  fontSize: 20.sp,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6.h),
            ZekrCountBadge(count: zekr.count),
          ],
        ),
      ),
    );
  }
}

/// عدد مرات الذكر ("٣ مرات") في كارت الذكر وفي شاشته
class ZekrCountBadge extends StatelessWidget {
  const ZekrCountBadge({super.key, required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.repeat_rounded, size: 15.sp, color: AppColors.primaryColor),
          SizedBox(width: 4.w),
          Text(
            S.of(context).zekrRepeat(count),
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
