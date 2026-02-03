
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/core/helper_functions/app_router.dart';
import 'package:islami/core/utils/app_colors.dart';

class AZkarCard extends StatelessWidget {
  const AZkarCard({
    super.key,
    required this.hint,
    required this.txt,
  });
  final String hint, txt;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(AppRouter.suoraSCreen, extra: [hint, txt]);
      },
      child: Container(
        constraints: BoxConstraints(maxWidth: 320.sp),
        padding: const EdgeInsetsDirectional.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.primaryColor, width: 2.0),
        ),
        child: Text(
          hint,
          style: GoogleFonts.amiri(
              fontSize: 20.sp,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
