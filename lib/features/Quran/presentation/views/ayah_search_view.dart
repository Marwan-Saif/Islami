import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/core/helper_functions/app_router.dart';
import 'package:islami/core/services/get_it.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/utils/quran_utils.dart';
import 'package:islami/core/widgets/appbar.dart';
import 'package:islami/features/Quran/domain/quran_repo.dart';
import 'package:islami/features/Quran/presentation/views/surah_view.dart';
import 'package:quran_with_tafsir/quran_with_tafsir.dart';

class AyahSearchView extends StatefulWidget {
  const AyahSearchView({super.key, required this.query});
  final String query;

  @override
  State<AyahSearchView> createState() => _AyahSearchViewState();
}

class _AyahSearchViewState extends State<AyahSearchView> {
  late final Future<List<Ayah>> _results =
      getit.get<QuranRepo>().searchAyahs(widget.query, limit: 100);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: customAppBar(context, 'نتائج «${widget.query}»'),
      body: FutureBuilder<List<Ayah>>(
        future: _results,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }
          final ayahs = snapshot.data ?? [];
          if (ayahs.isEmpty) {
            return Center(
              child: Text(
                'لا توجد آيات تحتوي على «${widget.query}»',
                style: TextStyle(color: Colors.white70, fontSize: 16.sp),
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.all(16.r),
            itemCount: ayahs.length,
            separatorBuilder: (context, index) =>
                const Divider(color: Colors.white12),
            itemBuilder: (context, index) {
              final ayah = ayahs[index];
              return InkWell(
                onTap: () => context.push(
                  AppRouter.surahScreen,
                  extra: SurahScreenArgs(ayah.surahNumber, initialAyah: ayah.id),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${surahTitle(ayah.surahNumber)} • آية ${ayah.id}',
                        style: TextStyle(color: Colors.white54, fontSize: 13.sp),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        cleanAyahText(ayah.text),
                        style: GoogleFonts.amiri(
                          color: AppColors.primaryColor,
                          fontSize: 19.sp,
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
