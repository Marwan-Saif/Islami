import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/widgets/brand/pattern_background.dart';
import 'package:islami/core/widgets/appbar.dart';
import 'package:islami/features/Timer/domain/zekr_entity.dart';
import 'package:islami/features/Timer/presentation/views/widgets/azkar_card.dart';
import 'package:islami/generated/l10n.dart';

/// شاشة الذكر: النص، وعدد مراته، وعدّاد بيتضغط لحد ما الذكر يخلص
class SuraSCreen extends StatefulWidget {
  const SuraSCreen({super.key, required this.zekr});
  final ZekrEntity zekr;

  @override
  State<SuraSCreen> createState() => _SuraSCreenState();
}

class _SuraSCreenState extends State<SuraSCreen> {
  int _done = 0;

  bool get _finished => _done >= widget.zekr.count;

  void _count() {
    setState(() {
      if (_finished) {
        _done = 0;
        return;
      }
      _done++;
    });
    // اهتزاز خفيف مع كل عدّة وأقوى لما الذكر يخلص، عشان يتعد من غير ما يبص
    _finished ? HapticFeedback.heavyImpact() : HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.zekr.count;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: customAppBar(context, ''),
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          const Positioned.fill(child: IslamicPatternLayer()),
          Positioned.fill(
            top: 16,
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  // الأذكار الطويلة لازم تعمل scroll، والقصيرة تفضل في النص
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: LayoutBuilder(
                        builder: (context, constraints) =>
                            SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight,
                                ),
                                child: Center(
                                  child: Text(
                                    widget.zekr.txt,
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.rtl,
                                    style: GoogleFonts.amiri(
                                      fontSize: 20.sp,
                                      color: AppColors.primaryColor,
                                      // من غيرها تشكيل السطر بيلزق في اللي
                                      // تحته (آية الكرسي مثلاً)
                                      height: 1.8,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ZekrCountBadge(count: count),
                  SizedBox(height: 12.h),
                  _ZekrCounter(done: _done, count: count, onTap: _count),
                  SizedBox(height: 8.h),
                  Text(
                    _finished
                        ? S.of(context).zekrDone
                        : S.of(context).tapToCount,
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13.sp,
                    ),
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ZekrCounter extends StatelessWidget {
  const _ZekrCounter({
    required this.done,
    required this.count,
    required this.onTap,
  });
  final int done;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final finished = done >= count;
    final size = 96.r;
    return Semantics(
      button: true,
      label: '$done ${S.of(context).zekrOutOf(count)}',
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox.square(
          dimension: size,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: done / count,
                strokeWidth: 5,
                color: AppColors.primaryColor,
                backgroundColor: AppColors.primaryColor.withValues(alpha: 0.2),
              ),
              Center(
                child: finished
                    ? Icon(
                        Icons.check_rounded,
                        color: AppColors.primaryColor,
                        size: 44.r,
                      )
                    // الرقم الكبير اللي اتعد وتحته "من 3"، بدل "0 / 3" اللي
                    // بيتقلب في الاتجاه العربي
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$done',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                          Text(
                            S.of(context).zekrOutOf(count),
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
