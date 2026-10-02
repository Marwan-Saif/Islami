import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/core/helper_functions/app_router.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/features/Hadith/data/hadith_books.dart';
import 'package:islami/features/Hadith/data/hadith_models.dart';
import 'package:islami/generated/l10n.dart';

/// قسم الأحاديث في الشاشة الرئيسية تحت الأذكار
class HadithBooksSection extends StatelessWidget {
  const HadithBooksSection({super.key});

  void _openBook(BuildContext context, HadithBook book) {
    // الأربعون النووية والقدسية باب واحد، فبتفتح الأحاديث على طول
    if (book.sections.length == 1) {
      context.push(AppRouter.hadithListView,
          extra: (book: book.key, section: book.sections.first.number));
    } else {
      context.push(AppRouter.hadithSectionsView, extra: book.key);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(start: 20.w),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              S.of(context).hadiths,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 110.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            itemCount: kHadithBooks.length + 1,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _BookCard(
                  title: S.of(context).favorites,
                  icon: Icons.favorite_rounded,
                  onTap: () => context.push(AppRouter.hadithFavoritesView),
                );
              }
              final book = kHadithBooks[index - 1];
              return _BookCard(
                title: book.name,
                icon: Icons.auto_stories_rounded,
                onTap: () => _openBook(context, book),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BookCard extends StatelessWidget {
  const _BookCard({required this.title, required this.icon, required this.onTap});
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        width: 130.w,
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColors.primaryColor, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primaryColor, size: 26.r),
            SizedBox(height: 6.h),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  style: GoogleFonts.amiri(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
