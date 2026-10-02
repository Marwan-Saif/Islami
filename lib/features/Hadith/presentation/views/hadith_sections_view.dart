import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:islami/core/helper_functions/app_router.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/widgets/appbar.dart';
import 'package:islami/features/Hadith/data/hadith_repo.dart';

/// أبواب كتاب الحديث
class HadithSectionsView extends StatelessWidget {
  const HadithSectionsView({super.key, required this.bookKey});
  final String bookKey;

  @override
  Widget build(BuildContext context) {
    final book = HadithRepo.instance.bookByKey(bookKey);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: customAppBar(context, book.name),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        itemCount: book.sections.length,
        separatorBuilder: (context, index) => const Divider(color: Colors.white12),
        itemBuilder: (context, index) {
          final section = book.sections[index];
          return ListTile(
            onTap: () => context.push(
              AppRouter.hadithListView,
              extra: (book: book.key, section: section.number),
            ),
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryColor.withValues(alpha: 0.15),
              child: Text('${section.number}',
                  style: const TextStyle(color: AppColors.primaryColor)),
            ),
            title: Text(section.rangeLabel,
                style: TextStyle(color: Colors.white, fontSize: 16.sp)),
            subtitle: Text(
              section.nameEn,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.white54, fontSize: 12.sp),
            ),
            trailing: Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.white38, size: 16.r),
          );
        },
      ),
    );
  }
}
