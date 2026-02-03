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

class ZekrListView extends StatelessWidget {
  const ZekrListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AzkarCubit(getit.get<ZekrRepo>())
        ..getAzkar(),
      child: ZekrListViewBodyConsumer(),
    );
  }
}

class ZekrListViewBodyConsumer extends StatelessWidget {
  const ZekrListViewBodyConsumer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AzkarCubit, AzkarState>(
      listener: (context, state) {},
      builder: (context, state) {
        log(state.toString());
        return state is! AzkarLoadedSuccessfuly
            ? const Center(child: CircularProgressIndicator())
            : AzkarListViewBody(
                azkar: state.zekrList,
              );
      },
    );
  }
}

class AzkarListViewBody extends StatelessWidget {
  const AzkarListViewBody({
    super.key,
    required this.azkar,
  });
  final List<List<ZekrEntity>> azkar;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.separated(
      padding:
          EdgeInsetsDirectional.symmetric(vertical: 20.sp, horizontal: 20.sp),
      itemBuilder: (context, index) => ZekrCard(
        name: kFileNames[index],
        zekrList: azkar[index],
      ),
      separatorBuilder: (context, index) => SizedBox(width: 20.sp),
      itemCount: 7,
      scrollDirection: Axis.horizontal,
    ));
  }
}
