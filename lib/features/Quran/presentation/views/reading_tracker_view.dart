import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:islami/core/helper_functions/app_router.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/utils/quran_utils.dart';
import 'package:islami/core/widgets/appbar.dart';
import 'package:islami/features/Quran/data/reading_tracker.dart';
import 'package:islami/features/Quran/presentation/views/surah_view.dart';
import 'package:islami/features/Quran/presentation/views/widgets/reading_tracker_card.dart';
import 'package:islami/generated/l10n.dart';

class ReadingTrackerView extends StatelessWidget {
  const ReadingTrackerView({super.key});

  static const List<int> _goalOptions = [1, 2, 4, 5, 10, 20];

  void _open(BuildContext context, ReadingPosition position) {
    context.push(
      AppRouter.surahScreen,
      extra: SurahScreenArgs(position.surah, initialAyah: position.ayah),
    );
  }

  Future<void> _pickGoal(BuildContext context) async {
    final tracker = ReadingTracker.instance;
    final picked = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppColors.backgroundColor,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12.h),
            Text(S.of(context).dailyWird,
                style: GoogleFonts.amiri(
                    color: AppColors.primaryColor,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold)),
            for (final pages in _goalOptions)
              ListTile(
                onTap: () => Navigator.of(context).pop(pages),
                title: Text(
                  pages == 20
                      ? S.of(context).fullJuz
                      : S.of(context).pagesCount(pages),
                  style: TextStyle(color: Colors.white, fontSize: 15.sp),
                ),
                subtitle: Text(
                  S.of(context).khatmaEveryDays(
                    (ReadingTracker.totalPages / pages).ceil(),
                  ),
                  style: TextStyle(color: Colors.white54, fontSize: 12.sp),
                ),
                trailing: pages == tracker.dailyGoal
                    ? const Icon(Icons.check, color: AppColors.primaryColor)
                    : null,
              ),
          ],
        ),
      ),
    );
    if (picked != null) await tracker.setDailyGoal(picked);
  }

  Future<void> _confirmReset(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundColor,
        title: Text(S.of(context).startNewKhatma,
            style: const TextStyle(color: AppColors.primaryColor)),
        content: Text(S.of(context).resetKhatmaConfirm,
            style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(S.of(context).cancel)),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(S.of(context).startOver,
                  style: const TextStyle(color: Colors.redAccent))),
        ],
      ),
    );
    if (confirmed == true) await ReadingTracker.instance.resetKhatma();
  }

  @override
  Widget build(BuildContext context) {
    final tracker = ReadingTracker.instance;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: customAppBar(context, S.of(context).readingTracker),
      body: ValueListenableBuilder<int>(
        valueListenable: tracker.changes,
        builder: (context, _, _) {
          final lastRead = tracker.lastRead;
          final bookmarks = tracker.bookmarks;
          return ListView(
            padding: EdgeInsets.all(16.r),
            children: [
              _Section(
                title: S.of(context).khatma,
                child: Row(
                  children: [
                    ProgressRing(progress: tracker.khatmaProgress, size: 84.r),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _InfoText(
                              S.of(context).readPagesOf(tracker.khatmaPages.length, ReadingTracker.totalPages)),
                          _InfoText(S.of(context).completedKhatmas(tracker.completedKhatmas)),
                          TextButton.icon(
                            onPressed: () => _confirmReset(context),
                            icon: const Icon(Icons.restart_alt_rounded),
                            label: Text(S.of(context).startNewKhatma),
                            style: TextButton.styleFrom(
                                foregroundColor: AppColors.primaryColor,
                                padding: EdgeInsets.zero),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _Section(
                title: S.of(context).dailyWird,
                action: TextButton(
                  onPressed: () => _pickGoal(context),
                  child: Text(S.of(context).editGoal,
                      style: const TextStyle(color: AppColors.primaryColor)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoText(
                        S.of(context).todayPagesOf(tracker.todayPages, tracker.dailyGoal)),
                    SizedBox(height: 8.h),
                    LinearProgressIndicator(
                      value: (tracker.todayPages / tracker.dailyGoal).clamp(0, 1),
                      minHeight: 8.h,
                      borderRadius: BorderRadius.circular(8.r),
                      color: AppColors.primaryColor,
                      backgroundColor: Colors.white12,
                    ),
                    SizedBox(height: 12.h),
                    _WeekChart(goal: tracker.dailyGoal),
                    SizedBox(height: 8.h),
                    _InfoText(S.of(context).streakDays(tracker.streak)),
                  ],
                ),
              ),
              if (lastRead != null)
                _Section(
                  title: S.of(context).lastRead,
                  child: _PositionTile(
                    position: lastRead,
                    icon: Icons.menu_book_rounded,
                    onTap: () => _open(context, lastRead),
                  ),
                ),
              _Section(
                title: S.of(context).bookmarks,
                child: bookmarks.isEmpty
                    ? _InfoText(S.of(context).bookmarksEmpty)
                    : Column(
                        children: [
                          for (final bookmark in bookmarks)
                            _PositionTile(
                              position: bookmark,
                              icon: Icons.bookmark_rounded,
                              onTap: () => _open(context, bookmark),
                              onDelete: () =>
                                  tracker.toggleBookmark(bookmark),
                            ),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.action});
  final String title;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.primaryColor.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title,
                    style: GoogleFonts.amiri(
                        color: AppColors.primaryColor,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold)),
              ),
              if (action != null) action!,
            ],
          ),
          SizedBox(height: 8.h),
          child,
        ],
      ),
    );
  }
}

class _InfoText extends StatelessWidget {
  const _InfoText(this.text);
  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: TextStyle(color: Colors.white, fontSize: 14.sp));
}

class _PositionTile extends StatelessWidget {
  const _PositionTile({
    required this.position,
    required this.icon,
    required this.onTap,
    this.onDelete,
  });
  final ReadingPosition position;
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.primaryColor),
      title: Text(S.of(context).ayahRef(surahTitle(position.surah), position.ayah),
          style: TextStyle(color: Colors.white, fontSize: 15.sp)),
      subtitle: Text(S.of(context).pageNumber(position.page),
          style: TextStyle(color: Colors.white54, fontSize: 12.sp)),
      trailing: onDelete == null
          ? null
          : IconButton(
              onPressed: onDelete,
              tooltip: S.of(context).deleteBookmark,
              icon: const Icon(Icons.delete_outline, color: Colors.white54),
            ),
    );
  }
}

/// صفحات آخر 7 أيام كأعمدة صغيرة
class _WeekChart extends StatelessWidget {
  const _WeekChart({required this.goal});
  final int goal;

  @override
  Widget build(BuildContext context) {
    final tracker = ReadingTracker.instance;
    final today = DateTime.now();
    // أول حرف من اسم اليوم حسب لغة التطبيق (ن ث ر... / M T W...)
    final dayLetter = DateFormat(
      'EEEEE',
      Localizations.localeOf(context).languageCode,
    );
    final days = [for (int i = 6; i >= 0; i--) today.subtract(Duration(days: i))];
    final maxPages = [
      goal,
      ...days.map(tracker.pagesReadOn),
    ].reduce((a, b) => a > b ? a : b);
    return SizedBox(
      height: 70.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final day in days)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: FractionallySizedBox(
                      heightFactor: (tracker.pagesReadOn(day) / maxPages)
                          .clamp(0.04, 1.0),
                      child: Container(
                        width: 14.w,
                        decoration: BoxDecoration(
                          color: tracker.pagesReadOn(day) >= goal
                              ? AppColors.primaryColor
                              : AppColors.primaryColor.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(dayLetter.format(day),
                      style: TextStyle(color: Colors.white54, fontSize: 11.sp)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
