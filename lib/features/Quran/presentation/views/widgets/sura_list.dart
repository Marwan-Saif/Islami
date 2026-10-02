import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami/features/Quran/presentation/manager/quran_cubit/quran_cubit.dart';
import 'package:islami/features/Quran/presentation/views/widgets/sura_card.dart';

class SurasList extends StatelessWidget {
  const SurasList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuranCubit, QuranState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is GetQuranSuccess && state.quranModel.data!.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Text(
              'لا توجد سورة بهذا الاسم',
              style: TextStyle(color: Colors.white70, fontSize: 16.sp),
            ),
          );
        }
        return state is !GetQuranSuccess
            ? const Center(
                child: CircularProgressIndicator(),
        ):
        Expanded(
          child: ListView.separated(
              itemCount: state.quranModel.data!.length,
              itemBuilder: (context, index) =>  SuraCard(surahModel: state.quranModel.data![index],),
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
