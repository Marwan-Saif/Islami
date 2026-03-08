import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/core/utils/app_images.dart';
import 'package:islami/features/Sebha/data/sebha_services.dart';
import 'package:islami/features/Sebha/presentation/views/local_sypha.dart';

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
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFC9A063)),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20.h), // استخدام .h للارتفاع

          Container(
            width: double.infinity,
            margin: EdgeInsetsDirectional.symmetric(
              horizontal: 60.w,
            ), 
            child: Image.asset(
              Assets.imagesMosque001,
              height: 150.h,
              fit: BoxFit.contain, 
            ),
          ),

          SizedBox(height: 40.h),

          carousalSliderSection(),

          SizedBox(height: 20.h),

          GestureDetector(
            onTap: () {
              setState(() {
                counter++;
                total++;
                _sebhaService.incrementCounter(currentIndex);
                _sebhaService.incrementGlobalTotal();
              });
            },
            child: Container(
              width: 300.w, 
              height: 350.h, 
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.imagesSebha),
                  fit: BoxFit.contain, 
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50.h,
                  ), 
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      selectedValue,
                      style: GoogleFonts.amiri(
                        fontSize: 32.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                    child: Text(
                      '$counter',
                      key: ValueKey<int>(counter),
                      style: GoogleFonts.amiri(
                        fontSize: 40.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFeatures: [const FontFeature('arab')],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // الإجمالي
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'الاجمالي :',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8.w),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Text(
                  '$total',
                  key: ValueKey<int>(total),
                  style: GoogleFonts.amiri(
                    fontSize: 30.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFeatures: [const FontFeature('arab')],
                  ),
                ),
              ),
            ],
          ),
          // أزرار التحكم
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    log("Refresh/Save to History");
                    _sebhaService.moveCurrentToHistory();
                    setState(() {
                      counter = 0;
                      total = 0;
                    });
                  },
                  child: Image.asset(
                    Assets.imagesRefresh,
                    width: 35.w,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    log("Reset History");
                    resetDialog(context);
                  },
                  child: Image.asset(
                    Assets.imagesReset,
                    width: 35.w,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 100.h), 
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
            style: GoogleFonts.amiri(fontSize: 32.sp, color: Colors.white),
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
                "السجل السابق",
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
                        color: Colors.black,
                        thickness: 1.5.h,
                        height: 20.h,
                      ),
                      Text(
                        'الاجمالي : ${_sebhaService.getTotalHistory()}',
                        style: TextStyle(
                          color: Colors.black,
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
                    this.setState(() {}); 
                  },
                  child: Text(
                    "تنظيف",
                    style: TextStyle(color: Colors.red, fontSize: 16.sp),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("إغلاق", style: TextStyle(fontSize: 16.sp)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
