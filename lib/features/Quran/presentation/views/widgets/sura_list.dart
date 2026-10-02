import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami/features/Quran/presentation/manager/quran_cubit/quran_cubit.dart';
import 'package:islami/features/Quran/presentation/views/widgets/sura_card.dart';
import 'package:islami/generated/l10n.dart';

class SurasList extends StatelessWidget {
  const SurasList({
    super.key,
  });

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
              style: TextStyle(color: Colors.white70, fontSize: 16.sp),
            ),
          );
        }
        return Expanded(
          child: ListView.separated(
              itemCount: state.surahs.length,
              itemBuilder: (context, index) =>
                  SuraCard(surah: state.surahs[index]),
              separatorBuilder: (context, index) => const Divider(
                    color: Colors.grey,
                    thickness: 1.5,
                    indent: 50,
                    endIndent: 50,
                  )),
        );
      },
    );
  }
}
