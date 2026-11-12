import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami/constants.dart';
import 'package:islami/core/services/get_it.dart';
import 'package:islami/features/Timer/domain/zekr_entity.dart';
import 'package:islami/features/Timer/domain/zekr_repo.dart';
import 'package:islami/features/Timer/presentation/manager/Azkar/azkar_cubit.dart';
import 'package:islami/features/Timer/presentation/views/widgets/zekr_card.dart';
import 'package:islami/generated/l10n.dart';

class ZekrListView extends StatelessWidget {
  const ZekrListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AzkarCubit(getit.get<ZekrRepo>())..getAzkar(),
      child: ZekrListViewBodyConsumer(),
    );
  }
}

class ZekrListViewBodyConsumer extends StatelessWidget {
  const ZekrListViewBodyConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AzkarCubit, AzkarState>(
      listener: (context, state) {},
      builder: (context, state) {
        log(state.toString());
        return state is! AzkarLoadedSuccessfuly
            ? const Center(child: CircularProgressIndicator())
            : AzkarListViewBody(azkar: state.zekrList);
      },
    );
  }
}

class AzkarListViewBody extends StatelessWidget {
  const AzkarListViewBody({super.key, required this.azkar});
  final List<List<ZekrEntity>> azkar;

  @override
  Widget build(BuildContext context) {
    // لازم تتقرا هنا مش جوه itemBuilder عشان الكروت تتبني تاني لما اللغة تتغير
    final names = azkarNames(S.of(context));
    // الارتفاع بيتحسب من محتوى الكارت بحجم الخط الفعلي: الدايرة + سطرين
    // للاسم + المسافات، عشان الاسم ميتقصش مع تكبير الخط في الشاشات الصغيرة
    final titleHeight = MediaQuery.textScalerOf(context).scale(18.sp) * 1.2 * 2;
    final height = 28 + 64.r + 12.h + titleHeight + 40.sp + 6;
    return SizedBox(
      height: height,
      child: ListView.separated(
        padding: EdgeInsetsDirectional.symmetric(
          vertical: 20.sp,
          horizontal: 20.sp,
        ),
        itemBuilder: (context, index) => ZekrCard(
          name: names[index],
          zekrList: azkar[index],
          icon: kAzkarIcons[index % kAzkarIcons.length],
        ),
        separatorBuilder: (context, index) => SizedBox(width: 20.sp),
        // كان مكتوب 7 ثابت فـ "أذكار النوم" (الملف التامن) مكنتش بتظهر
        itemCount: azkar.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
