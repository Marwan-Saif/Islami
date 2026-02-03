import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/core/helper_functions/app_router.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/utils/app_images.dart';
import 'package:islami/features/Timer/domain/zekr_entity.dart';

class ZekrCard extends StatelessWidget {
  const ZekrCard({
    super.key,
    required this.name,
    required this.zekrList,
  });
  final String name;
  final List<ZekrEntity> zekrList;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
      
        context.push(AppRouter.zekrScreen, extra: {
          "azkarList":zekrList,
          "title":name
        });
      },
      child: Container(
        width: 160.sp,
        padding:
            const EdgeInsetsDirectional.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryColor, width: 2),
            borderRadius: BorderRadius.circular(20),
            color: AppColors.backgroundColor),
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                Assets.imagesIllustration,
                // width: 120.sp,
              ),
            ),
            Text(name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.amiri(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      ),
    );
  }
}
