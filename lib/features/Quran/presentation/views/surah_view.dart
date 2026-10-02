import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/utils/app_images.dart';
import 'package:islami/core/utils/quran_utils.dart';
import 'package:islami/core/widgets/appbar.dart';
import 'package:islami/features/Quran/presentation/views/widgets/surah_body.dart';

class SurahScreenArgs {
  const SurahScreenArgs(this.surahNumber, {this.initialAyah});
  final int surahNumber;

  /// لو موجودة الشاشة بتفتح على الصفحة اللي فيها الآية دي
  final int? initialAyah;
}

class SurahScreen extends StatelessWidget {
  const SurahScreen({super.key, required this.args});
  final SurahScreenArgs args;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: customAppBar(context, surahTitle(args.surahNumber)),
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
              color: AppColors.primaryColor.withValues(alpha: 0.4),
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
            left: 24,
            right: 24,
            top: 60.sp,
            bottom: 70,
            child: SurahBody(
              surahNumber: args.surahNumber,
              initialAyah: args.initialAyah,
            ),
          ),
        ],
      ),
    );
  }
}
