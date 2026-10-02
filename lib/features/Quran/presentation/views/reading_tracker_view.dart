import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/core/helper_functions/app_router.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/utils/quran_utils.dart';
import 'package:islami/core/widgets/appbar.dart';
import 'package:islami/features/Quran/data/reading_tracker.dart';
import 'package:islami/features/Quran/presentation/views/surah_view.dart';
import 'package:islami/features/Quran/presentation/views/widgets/reading_tracker_card.dart';

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
            Text('الورد اليومي',
                style: GoogleFonts.amiri(
                    color: AppColors.primaryColor,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold)),
            for (final pages in _goalOptions)
              ListTile(
                onTap: () => Navigator.of(context).pop(pages),
                title: Text(
                  pages == 20 ? 'جزء كامل (20 صفحة)' : '$pages ${pages <= 10 && pages > 2 ? 'صفحات' : 'صفحة'}',
                  style: TextStyle(color: Colors.white, fontSize: 15.sp),
                ),
                subtitle: Text(
                  'ختمة كل ${(ReadingTracker.totalPages / pages).ceil()} يوم تقريباً',
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
        title: const Text('بدء ختمة جديدة',
            style: TextStyle(color: AppColors.primaryColor)),
        content: const Text('سيتم تصفير تقدم الختمة الحالية، هل أنت متأكد؟',
            style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('إلغاء')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('ابدأ من جديد',
                  style: TextStyle(color: Colors.redAccent))),
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
      appBar: customAppBar(context, 'متابعة التلاوة'),
      body: ValueListenableBuilder<int>(
        valueListenable: tracker.changes,
        builder: (context, _, _) {
          final lastRead = tracker.lastRead;
          final bookmarks = tracker.bookmarks;
          return ListView(
            padding: EdgeInsets.all(16.r),
            children: [
              _Section(
                title: 'الختمة',
                child: Row(
                  children: [
                    ProgressRing(progress: tracker.khatmaProgress, size: 84.r),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _InfoText(
                              'قرأت ${tracker.khatmaPages.length} من ${ReadingTracker.totalPages} صفحة'),
                          _InfoText('الختمات المكتملة: ${tracker.completedKhatmas}'),
                          TextButton.icon(
                            onPressed: () => _confirmReset(context),
                            icon: const Icon(Icons.restart_alt_rounded),
                            label: const Text('بدء ختمة جديدة'),
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
                title: 'الورد اليومي',
                action: TextButton(
                  onPressed: () => _pickGoal(context),
                  child: const Text('تعديل الهدف',
                      style: TextStyle(color: AppColors.primaryColor)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoText(
                        'اليوم ${tracker.todayPages} من ${tracker.dailyGoal} صفحات'),
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
                    _InfoText('أيام متتالية: ${tracker.streak}'),
                  ],
                ),
              ),
              if (lastRead != null)
                _Section(
                  title: 'آخر قراءة',
                  child: _PositionTile(
                    position: lastRead,
                    icon: Icons.menu_book_rounded,
                    onTap: () => _open(context, lastRead),
                  ),
                ),
              _Section(
                title: 'العلامات',
                child: bookmarks.isEmpty
                    ? const _InfoText(
                        'اضغط مطولاً على أي آية واختار "إضافة علامة"')
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
      title: Text('${surahTitle(position.surah)} - آية ${position.ayah}',
          style: TextStyle(color: Colors.white, fontSize: 15.sp)),
      subtitle: Text('صفحة ${position.page}',
          style: TextStyle(color: Colors.white54, fontSize: 12.sp)),
      trailing: onDelete == null
          ? null
          : IconButton(
              onPressed: onDelete,
              tooltip: 'حذف العلامة',
              icon: const Icon(Icons.delete_outline, color: Colors.white54),
            ),
    );
  }
}

/// صفحات آخر 7 أيام كأعمدة صغيرة
class _WeekChart extends StatelessWidget {
  const _WeekChart({required this.goal});
  final int goal;

  static const List<String> _dayNames = ['ن', 'ث', 'ر', 'خ', 'ج', 'س', 'ح'];

  @override
  Widget build(BuildContext context) {
    final tracker = ReadingTracker.instance;
    final today = DateTime.now();
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
                  Text(_dayNames[day.weekday - 1],
                      style: TextStyle(color: Colors.white54, fontSize: 11.sp)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
