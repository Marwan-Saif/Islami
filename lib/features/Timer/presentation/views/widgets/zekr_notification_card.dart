import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami/core/services/get_it.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/features/Timer/data/hive/zekr_localdata.dart';
import 'package:islami/features/Timer/domain/zekr_repo.dart';
import 'package:islami/features/Timer/presentation/manager/Azkar/azkar_cubit.dart';

class NotificationCard extends StatefulWidget {
  const NotificationCard(
      {super.key, required this.showen, required this.index});
  final bool showen;
  final int index;
  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  String timePicked = "00:00";
  TimeOfDay timeOfDay = TimeOfDay.now();
  bool selected = false;
  ZekrLocalDataMoel? zekrLocalDataMoel;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log("indeeeeeeeex ${widget.index}");
    return BlocProvider(
      create: (context) =>
          AzkarCubit(getit.get<ZekrRepo>())..getAzkarLocalData(),
      child: BlocConsumer<AzkarCubit, AzkarState>(
        listener: (context, state) {},
        builder: (context, state) {
          return state is getlocalDataloading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  padding: EdgeInsetsDirectional.symmetric(
                      vertical: 20.sp, horizontal: 20.sp),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.primaryColor),
                  child: Column(children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 200,
                          child: Text(
                            "تفعيل الاشعارات",
                            maxLines: 2,
                            style: TextStyle(
                                color: AppColors.backgroundColor,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Spacer(),
                        Switch(
                          value: context
                              .read<AzkarCubit>()
                              .azkarLocalDataList[widget.index]
                              .zekrAllawed,
                          onChanged: (value) {
                            setState(() {
                              context.read<AzkarCubit>().updatelocalData(
                                  index: widget.index, allowed: value);
                              selected = value;
                            });
                          },
                          activeColor: AppColors.primaryColor,
                          activeTrackColor: AppColors.secondaryColor,
                          inactiveThumbColor: AppColors.primaryColor,
                          inactiveTrackColor: AppColors.backgroundColor,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 150,
                          child: Text(
                            "الوقت المحدد لارسال الاشعارات : ${context.read<AzkarCubit>().azkarLocalDataList[widget.index].zekrtime}",
                            maxLines: 2,
                            style: TextStyle(
                                color: AppColors.backgroundColor,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                            onTap: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((value) {
                                log(
                                  value.toString(),
                                );
                                //في فرق ساعتين
                                timeOfDay = value ?? TimeOfDay.now();
                                timePicked = value!.hour.toString() +
                                    ":" +
                                    value.minute.toString();
                                log(timePicked);
                                context.read<AzkarCubit>().updatelocalData(
                                    index: widget.index,
                                    time: timePicked.toString());
                                setState(() {});
                              });
                            },
                            child: const Icon(Icons.history_toggle_off_sharp))
                      ],
                    )
                  ]),
                );
        },
      ),
    );
  }
}
