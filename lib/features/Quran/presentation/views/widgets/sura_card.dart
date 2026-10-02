import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/core/helper_functions/app_router.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/utils/quran_utils.dart';
import 'package:islami/core/widgets/ayah_number.dart';
import 'package:islami/features/Quran/presentation/views/surah_view.dart';
import 'package:islami/generated/l10n.dart';
import 'package:quran_with_tafsir/quran_with_tafsir.dart';

class SuraCard extends StatelessWidget {
  const SuraCard({super.key, required this.surah});
  final SurahMetadata surah;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(AppRouter.surahScreen, extra: SurahScreenArgs(surah.number));
      },
      highlightColor: AppColors.primaryColor.withValues(alpha: 0.2),
      splashColor: AppColors.primaryColor.withValues(alpha: 0),
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
          AyahNumber(number: surah.number),
          SizedBox(width: 8.w),
          // long names (e.g. Aal-i-Imraan) scale down instead of overflowing
          Expanded(
            flex: 5,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              // the row is forced LTR while the app is RTL, so align explicitly
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah.nameEn,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '   ${S.of(context).Verse} ${surah.ayahCount}',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            flex: 4,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                surahTitle(surah.number),
                style: GoogleFonts.amiri(
                  color: Colors.white,
                  fontSize: 26.sp,
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
