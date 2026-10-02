import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:islami/core/helper_functions/app_router.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/utils/quran_utils.dart';
import 'package:islami/features/Quran/data/reading_tracker.dart';
import 'package:islami/features/Quran/presentation/views/surah_view.dart';
import 'package:islami/generated/l10n.dart';

/// كارت صغير فوق قائمة السور: الختمة والورد اليومي و"أكمل القراءة"
class ReadingTrackerCard extends StatelessWidget {
  const ReadingTrackerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final tracker = ReadingTracker.instance;
    return ValueListenableBuilder<int>(
      valueListenable: tracker.changes,
      builder: (context, _, _) {
        final lastRead = tracker.lastRead;
        final progress = tracker.khatmaProgress;
        return InkWell(
          onTap: () => context.push(AppRouter.readingTrackerView),
          borderRadius: BorderRadius.circular(18.r),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.h),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                  color: AppColors.primaryColor.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                ProgressRing(progress: progress, size: 50.r),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        S.of(context).readingTracker,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        S.of(context).todayWird(tracker.todayPages, tracker.dailyGoal) +
                            (tracker.streak > 1 ? S.of(context).streakSuffix(tracker.streak) : ''),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                      ),
                      Text(
                        lastRead == null
                            ? S.of(context).startKhatmaHint
                            : S.of(context).lastReadAt(
                                S.of(context).ayahRef(surahTitle(lastRead.surah), lastRead.ayah),
                              ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white54, fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                FilledButton(
                  onPressed: () => context.push(
                    AppRouter.surahScreen,
                    extra: lastRead == null
                        ? const SurahScreenArgs(1)
                        : SurahScreenArgs(lastRead.surah,
                            initialAyah: lastRead.ayah),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.backgroundColor,
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Text(lastRead == null
                      ? S.of(context).start
                      : S.of(context).continueReading),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProgressRing extends StatelessWidget {
  const ProgressRing({super.key, required this.progress, required this.size});
  final double progress;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: size / 10,
              color: AppColors.primaryColor,
              backgroundColor: Colors.white12,
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: EdgeInsets.all(size / 6),
              child: Text(
                '${(progress * 100).floor()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
