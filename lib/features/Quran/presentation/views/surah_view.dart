import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/widgets/brand/pattern_background.dart';
import 'package:islami/core/utils/quran_utils.dart';
import 'package:islami/core/widgets/appbar.dart';
import 'package:islami/features/Quran/presentation/views/widgets/surah_body.dart';
import 'package:islami/features/Radio/presentation/views/widgets/mini_player.dart';

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
          const Positioned.fill(child: IslamicPatternLayer()),
          Positioned.fill(
            top: 8.h,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                    child: SurahBody(
                      surahNumber: args.surahNumber,
                      initialAyah: args.initialAyah,
                    ),
                  ),
                ),
                // تحكم في صوت الآية (إيقاف/تشغيل) من غير ما تسيب السورة،
                // وبيختفي لوحده لو مفيش حاجة متحملة في المشغل
                const SafeArea(top: false, child: MiniPlayer()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
