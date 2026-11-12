import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/widgets/brand/pattern_background.dart';
import 'package:islami/core/widgets/appbar.dart';
import 'package:islami/features/Radio/presentation/views/widgets/mini_player.dart';

/// نفس إطار شاشات الأذكار والسور (الزخارف فوق والمسجد تحت) + مشغل صغير
class RecitationScaffold extends StatelessWidget {
  const RecitationScaffold({
    super.key,
    required this.title,
    required this.body,
  });
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
          const Positioned.fill(child: IslamicPatternLayer()),
          Positioned.fill(
            top: 8.h,
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
