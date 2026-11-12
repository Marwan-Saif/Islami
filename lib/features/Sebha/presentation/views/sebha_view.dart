import 'package:islami/core/utils/app_colors.dart';
import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/core/widgets/brand/brand_header.dart';
import 'package:islami/features/Sebha/presentation/views/widgets/sebha_beads.dart';
import 'package:islami/features/Sebha/data/sebha_services.dart';
import 'package:islami/features/Sebha/presentation/views/local_sypha.dart';
import 'package:islami/generated/l10n.dart';

class SebhaView extends StatefulWidget {
  const SebhaView({super.key});

  @override
  State<SebhaView> createState() => _SebhaViewState();
}

class _SebhaViewState extends State<SebhaView> {
  final SebhaService _sebhaService = SebhaService();

  bool _isLoading = true;
  int counter = 0;
  String selectedValue = "سبحان الله";
  int currentIndex = 0;
  int total = 0;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await _sebhaService.init();

    setState(() {
      total = _sebhaService.getGlobalTotal();
      var currentItem = _sebhaService.getZekrAt(currentIndex);
      selectedValue = currentItem.name;
      counter = int.parse(currentItem.counter);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      );
    }

    // الصفحة بتاخد ارتفاع التاب بالظبط من غير scroll: كل جزء ليه نسبة من
    // المساحة، فبتظبط على الشاشات الصغيرة والكبيرة وأحجام الخط المختلفة
    return SafeArea(
      bottom: false,
      child: Padding(
        // مساحة لدواير الـ bottom nav اللي طالعة فوق الشريط
        padding: EdgeInsets.only(
          top: 12.h,
          bottom: MediaQuery.paddingOf(context).bottom + 8.h,
        ),
        child: Column(
          children: [
            const BrandHeader(),
            SizedBox(height: 8.h),
            carousalSliderSection(),
            SizedBox(height: 8.h),
            Expanded(flex: 9, child: _beads()),
            SizedBox(height: 8.h),
            _totalRow(),
            SizedBox(height: 8.h),
            _actionsRow(),
          ],
        ),
      ),
    );
  }

  void _increment() {
    setState(() {
      counter++;
      total++;
      _sebhaService.incrementCounter(currentIndex);
      _sebhaService.incrementGlobalTotal();
    });
  }

  // السبحة بتحافظ على نسبة الصورة وبتكبر وتصغر مع المساحة المتاحة،
  // والذكر والعداد جواها مقاسهم نسبة من حجمها
  Widget _beads() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _increment,
      child: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final height = constraints.maxHeight;
              return SebhaBeads(
                count: counter,
                child: Padding(
                  // الكلام جوه الدايرة اللي نازلة شوية بسبب الشرّابة اللي فوق
                  padding: EdgeInsets.fromLTRB(
                    height * 0.2,
                    height * 0.3,
                    height * 0.2,
                    height * 0.18,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          selectedValue,
                          style: GoogleFonts.amiri(
                            fontSize: height * 0.085,
                            color: AppColors.text,
                          ),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(scale: animation, child: child),
                          child: Text(
                            '$counter',
                            key: ValueKey<int>(counter),
                            style: GoogleFonts.amiri(
                              fontSize: height * 0.11,
                              color: AppColors.text,
                              fontWeight: FontWeight.bold,
                              fontFeatures: [const FontFeature('arab')],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _totalRow() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            S.of(context).totalLabel,
            style: TextStyle(
              color: AppColors.text,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8.w),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Text(
              '$total',
              key: ValueKey<int>(total),
              style: GoogleFonts.amiri(
                fontSize: 30.sp,
                color: AppColors.text,
                fontWeight: FontWeight.bold,
                fontFeatures: [const FontFeature('arab')],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionsRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // IconButton: مساحة لمس 48dp وتأثير ضغط واسم للقارئ الصوتي
          IconButton(
            onPressed: () {
              log("Refresh/Save to History");
              _sebhaService.moveCurrentToHistory();
              setState(() {
                counter = 0;
                total = 0;
              });
            },
            tooltip: S.of(context).saveToHistory,
            iconSize: 30.r,
            color: AppColors.primaryColor,
            icon: const Icon(Icons.restart_alt_rounded),
          ),
          IconButton(
            onPressed: () {
              log("Reset History");
              resetDialog(context);
            },
            tooltip: S.of(context).history,
            iconSize: 30.r,
            color: AppColors.primaryColor,
            icon: const Icon(Icons.history_rounded),
          ),
        ],
      ),
    );
  }

  CarouselSlider carousalSliderSection() {
    List<LocalSypha> azkarList = _sebhaService.getAllAzkar();

    return CarouselSlider.builder(
      itemCount: azkarList.length,
      itemBuilder: (context, index, realIndex) {
        return FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            azkarList[index].name,
            style: GoogleFonts.amiri(fontSize: 32.sp, color: AppColors.text),
          ),
        );
      },
      options: CarouselOptions(
        height: 50.h,
        viewportFraction: 0.52,
        enlargeCenterPage: true,
        enlargeFactor: 0.5,
        initialPage: currentIndex,
        enableInfiniteScroll: true,
        onPageChanged: (index, reason) {
          setState(() {
            currentIndex = index;
            var currentItem = _sebhaService.getZekrAt(index);
            selectedValue = currentItem.name;
            counter = int.parse(currentItem.counter);
          });
        },
      ),
    );
  }

  Future<dynamic> resetDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            List<LocalSypha> azkarList = _sebhaService.getAllAzkar();

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              title: Text(
                S.of(context).history,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              content: ConstrainedBox(
                // ConstrainedBox أفضل من SizedBox الثابت لمنع الـ Overflow
                constraints: BoxConstraints(maxHeight: 250.h),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...List.generate(azkarList.length, (index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: azkarList[index].name,
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                                const TextSpan(text: " : "),
                                TextSpan(
                                  text: azkarList[index].historyCounter,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      Divider(
                        color: AppColors.divider,
                        thickness: 1.5.h,
                        height: 20.h,
                      ),
                      Text(
                        S.of(context).total(_sebhaService.getTotalHistory()),
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actionsAlignment: MainAxisAlignment.spaceAround,
              actions: [
                TextButton(
                  onPressed: () {
                    _sebhaService.clearHistoryData();
                    setStateDialog(() {});
                    setState(() {});
                  },
                  child: Text(
                    S.of(context).clear,
                    style: TextStyle(color: AppColors.danger, fontSize: 16.sp),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    S.of(context).close,
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
