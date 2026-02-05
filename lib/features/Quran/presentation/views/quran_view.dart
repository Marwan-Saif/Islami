import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami/core/services/get_it.dart';
import 'package:islami/core/utils/app_images.dart';
import 'package:islami/features/Quran/domain/quran_repo.dart';
import 'package:islami/features/Quran/presentation/manager/quran_cubit/quran_cubit.dart';
import 'package:islami/features/Quran/presentation/views/widgets/search_textfield.dart';
import 'package:islami/features/Quran/presentation/views/widgets/sura_list.dart';
import 'package:islami/generated/l10n.dart';

class QuranView extends StatelessWidget {
  const QuranView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuranCubit(getit.get<QuranRepo>())..getQuran(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.sp),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsetsDirectional.symmetric(horizontal: 60.sp),
            child: Image.asset(
              Assets.imagesMosque001,
              width: 200.sp,
            ),
          ),
          //*****Screen */
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(children: [
                const SearchTextField(),
                Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      S.of(context).Suras_List,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold),
                    )),
                const SurasList()
              ]),
            ),
          )
        ],
      ),
    );
  }
}
