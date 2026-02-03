import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/constants.dart';
import 'package:islami/core/helper_functions/app_router.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/utils/app_images.dart';
import 'package:islami/core/widgets/appbar.dart';
import 'package:islami/features/Timer/domain/zekr_entity.dart';
import 'package:islami/features/Timer/presentation/views/widgets/azkar_card.dart';
import 'package:islami/features/Timer/presentation/views/widgets/zekr_notification_card.dart';

class ZekrView extends StatefulWidget {
  ZekrView({super.key, required this.azkarList, required this.title});
  final List<ZekrEntity> azkarList;
  final String title;

  @override
  State<ZekrView> createState() => _ZekrViewState();
}

class _ZekrViewState extends State<ZekrView> {
  // String timePicked = "00:00:00";
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: customAppBar(context, widget.title),
        body: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 0,
              right: 12,
              child: Image.asset(Assets.imagesMaskgroupRight),
            ),
            Positioned(
              top: 0,
              left: 12,
              child: Image.asset(Assets.imagesMaskgroupLeft),
            ),
            Positioned.fill(
              top: 70.sp,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                    start: 25, end: 25, bottom: 66),
                child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: widget.title == kFileNames[0] ||
                                widget.title == kFileNames[1]
                            ? NotificationCard(
                                index: kFileNames.indexOf(widget.title),
                                showen: widget.title == kFileNames[0] ||
                                    widget.title == kFileNames[1],
                              )
                            : const SizedBox(),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: 20.sp)),
                      SliverList.separated(
                        itemBuilder: (context, index) => AZkarCard(
                          hint: widget.azkarList[index].hint,
                          txt: widget.azkarList[index].txt,
                        ),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 20.sp),
                        itemCount: widget.azkarList.length,
                      ),
                    ]),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                Assets.imagesMosque02,
                fit: BoxFit.cover,
                color: AppColors.primaryColor.withOpacity(0.4),
              ),
            ),
          ],
        ));
  }
}
