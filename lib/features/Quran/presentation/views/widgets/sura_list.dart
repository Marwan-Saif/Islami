import 'package:islami/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami/features/Quran/presentation/manager/quran_cubit/quran_cubit.dart';
import 'package:islami/features/Quran/presentation/views/widgets/sura_card.dart';
import 'package:islami/generated/l10n.dart';

class SurasList extends StatelessWidget {
  const SurasList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranCubit, QuranState>(
      builder: (context, state) {
        if (state is! GetQuranSuccess) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.surahs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Text(
              S.of(context).noSurahFound,
              style: TextStyle(color: AppColors.textMuted, fontSize: 16.sp),
            ),
          );
        }
        return Expanded(
          child: ListView.separated(
            // من غيرها الـ ListView بيضيف مسافة شريط الحالة فوق أول سورة
            // (الهيدر واخدها خلاص)، فكان فيه فراغ كبير تحت "قائمة السور"
            padding: EdgeInsets.only(
              top: 4.h,
              bottom: MediaQuery.paddingOf(context).bottom + 16.h,
            ),
            itemCount: state.surahs.length,
            itemBuilder: (context, index) =>
                SuraCard(surah: state.surahs[index]),
            separatorBuilder: (context, index) => Divider(
              color: AppColors.divider,
              thickness: 1,
              indent: 50,
              endIndent: 50,
            ),
          ),
        );
      },
    );
  }
}
