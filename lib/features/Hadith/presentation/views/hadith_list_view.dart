import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/widgets/appbar.dart';
import 'package:islami/features/Hadith/data/hadith_models.dart';
import 'package:islami/features/Hadith/data/hadith_repo.dart';
import 'package:islami/features/Hadith/presentation/views/widgets/hadith_card.dart';

/// أحاديث باب واحد (بتتنزل أول مرة وبعدين بتفتح من غير نت)
class HadithListView extends StatefulWidget {
  const HadithListView({super.key, required this.bookKey, required this.sectionNumber});
  final String bookKey;
  final int sectionNumber;

  @override
  State<HadithListView> createState() => _HadithListViewState();
}

class _HadithListViewState extends State<HadithListView> {
  final _repo = HadithRepo.instance;
  late final HadithBook _book = _repo.bookByKey(widget.bookKey);
  late final HadithSection _section =
      _book.sections.firstWhere((s) => s.number == widget.sectionNumber);
  late Future<List<Hadith>> _hadiths = _repo.getSection(_book, _section);

  void _retry() => setState(() => _hadiths = _repo.getSection(_book, _section));

  @override
  Widget build(BuildContext context) {
    final title = _book.sections.length == 1 ? _book.name : _section.rangeLabel;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: customAppBar(context, title),
      body: FutureBuilder<List<Hadith>>(
        future: _hadiths,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.wifi_off_rounded,
                      color: AppColors.primaryColor, size: 48.r),
                  SizedBox(height: 12.h),
                  Text('تعذر تحميل الأحاديث، تأكد من الاتصال بالإنترنت',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 15.sp)),
                  SizedBox(height: 12.h),
                  OutlinedButton(
                    onPressed: _retry,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryColor,
                      side: const BorderSide(color: AppColors.primaryColor),
                    ),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }
          final hadiths = snapshot.data!;
          return ListView.separated(
            padding: EdgeInsets.all(16.r),
            itemCount: hadiths.length,
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemBuilder: (context, index) => HadithCard(hadith: hadiths[index]),
          );
        },
      ),
    );
  }
}

class HadithFavoritesView extends StatelessWidget {
  const HadithFavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = HadithRepo.instance;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: customAppBar(context, 'الأحاديث المفضلة'),
      body: ValueListenableBuilder<int>(
        valueListenable: repo.favoritesChanges,
        builder: (context, _, _) => FutureBuilder<List<Hadith>>(
          future: repo.getFavorites(),
          builder: (context, snapshot) {
            final favorites = snapshot.data;
            if (favorites == null) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              );
            }
            if (favorites.isEmpty) {
              return Center(
                child: Text('اضغط على ♡ في أي حديث لإضافته هنا',
                    style: TextStyle(color: Colors.white70, fontSize: 15.sp)),
              );
            }
            return ListView.separated(
              padding: EdgeInsets.all(16.r),
              itemCount: favorites.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) => HadithCard(
                key: ValueKey('${favorites[index].bookKey}_${favorites[index].number}'),
                hadith: favorites[index],
                showBookName: true,
              ),
            );
          },
        ),
      ),
    );
  }
}
