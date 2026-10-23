import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/widgets/brand/athar_logo.dart';
import 'package:islami/generated/l10n.dart';

/// اسم التطبيق بخط أميري ("أثر" / "Athar")
class BrandName extends StatelessWidget {
  const BrandName({super.key, this.fontSize = 30});
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      S.of(context).appName,
      style: GoogleFonts.amiri(
        fontSize: fontSize,
        height: 1.2,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryColor,
      ),
    );
  }
}

/// الهيدر اللي فوق التابات: اللوجو والاسم، و[trailing] اختياري (زرار الإعدادات)
class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key, this.trailing});
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 12.w, 4.h),
        child: Row(
          children: [
            AtharLogo(size: 46.r),
            SizedBox(width: 8.w),
            BrandName(fontSize: 26.sp),
            const Spacer(),
            ?trailing,
          ],
        ),
      ),
    );
  }
}
