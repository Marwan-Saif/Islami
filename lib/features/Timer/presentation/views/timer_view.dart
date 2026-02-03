import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami/core/utils/app_images.dart';
import 'package:islami/features/Timer/data/zekr_repo_impl.dart';
import 'package:islami/features/Timer/presentation/views/widgets/timer_section.dart';
import 'package:islami/features/Timer/presentation/views/widgets/zekr_section.dart';

class TimerView extends StatelessWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20.sp),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 60),
          child: Image.asset(
            Assets.imagesMosque001,
            // width: 200.sp,
            height: 150.sp,
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(
          height: 20.sp,
        ),
        PrayerTimer(),
        SizedBox(
          height: 10.sp,
        ),
        const Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Text(
            '    الأذكار  ',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),

        //zekr card
        const ZekrListView()
      ],
    );
  }
}
