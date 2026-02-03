
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:islami/core/helper_functions/app_router.dart';
import 'package:islami/core/widgets/ayah_number.dart';
import 'package:islami/features/Quran/data/models/surah_model.dart';
import 'package:islami/generated/l10n.dart';

class SuraCard extends StatelessWidget {
  const SuraCard({
    super.key, required this.surahModel,
  });
  final SurahModel surahModel ;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(AppRouter.surahScreen, extra: surahModel.ayahs);
      },
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
           AyahNumber(number: surahModel.number!,),
          const Spacer(
            flex: 1,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(surahModel.englishName!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  )),
              Text(
                '   ${S.of(context).Verse} ${surahModel.ayahs!.last.numberInSurah}',
                textDirection: TextDirection.rtl,
                style:  TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          const Spacer(
            flex: 9,
          ),
           Text(surahModel.name!,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ))
        ],
      ),
    );
  }
}
