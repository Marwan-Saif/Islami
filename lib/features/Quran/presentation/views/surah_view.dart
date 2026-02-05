import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/utils/app_images.dart';
import 'package:islami/core/widgets/appbar.dart';
import 'package:islami/features/Quran/data/models/surah_model.dart';
import 'package:islami/features/Quran/presentation/views/widgets/surah_body.dart';

class SurahScreen extends StatelessWidget {
  const SurahScreen({super.key, required this.ayahs});
  final List<Ayahs> ayahs;
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

          Positioned.fill(
            left: 30,
            right: 30,
            top: 80.sp,
            bottom: 90,
            child: SurahBody(ayahs: ayahs),
          ),
        ],
      ),
    );
  }
}
