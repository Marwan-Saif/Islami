import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/utils/app_images.dart';
import 'package:islami/core/widgets/appbar.dart';
import 'package:islami/features/Radio/presentation/views/widgets/mini_player.dart';

/// نفس إطار شاشات الأذكار والسور (الزخارف فوق والمسجد تحت) + مشغل صغير
class RecitationScaffold extends StatelessWidget {
  const RecitationScaffold({super.key, required this.title, required this.body});
  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: customAppBar(context, title),
      body: Stack(
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
            top: 0,
            right: 12,
            child: Image.asset(Assets.imagesMaskgroupRight),
          ),
          Positioned(
            top: 0,
            left: 12,
            child: Image.asset(Assets.imagesMaskgroupLeft),
          ),
          Positioned.fill(
            top: 40.h,
            child: Column(
              children: [
                Expanded(child: body),
                const SafeArea(top: false, child: MiniPlayer()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
