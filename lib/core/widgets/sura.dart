import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/utils/app_images.dart';
import 'package:islami/core/widgets/appbar.dart';

class SuraSCreen extends StatelessWidget {
  const SuraSCreen({super.key, required this.txt});
  final List<String> txt;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: customAppBar(context, ''),
        body: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                Assets.imagesMosque02,
                fit: BoxFit.cover,
                color: AppColors.primaryColor.withOpacity(0.4),
              ),
            ),
            Positioned(
              top: 8,
              right: 12,
              child: Image.asset(Assets.imagesMaskgroupRight),
            ),
            Positioned(
              top: 8,
              left: 12,
              child: Image.asset(Assets.imagesMaskgroupLeft),
            ),
            // Positioned(
            //   top: 20,
            //   left: 60,
            //   right: 60,
            //   // right: 0,
            //   child: Text(
            //       txt[0],
            //       textAlign: TextAlign.center,
                  
            //       style: TextStyle(
            //         color: AppColors.primaryColor,
            //         fontSize: 20.sp,
            //         fontWeight: FontWeight.bold,
            //       )),
            // ),
            Positioned(
                left: 30,
                right: 30,
                top: 90,
                bottom: 90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      child: Text(
                        txt[1],
                        textAlign: TextAlign
                            .center, // Align the text to the right for Arabic
                        style: GoogleFonts.amiri(
                          fontSize: 20.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        ));
  }
}
