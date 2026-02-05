import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:islami/core/services/shared_prefs.dart';
import 'package:islami/core/utils/app_images.dart';
import 'package:islami/features/Sebha/presentation/views/local_sypha.dart';

class SebhaView extends StatefulWidget {
  const SebhaView({super.key});

  @override
  State<SebhaView> createState() => _SebhaViewState();
}

class _SebhaViewState extends State<SebhaView> {
  int counter = 0;
  String selectedValue = "سبحان الله";
  late Box<LocalSypha> syphaBox;
  int currentIndex = 0;
  int total = 0;
  int totalHistory = 0;

  @override
  void initState() {
    super.initState();
    total = Prefs.getData(key: 'total') ?? 0;
    openBox();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        //*****Screen */
        SizedBox(height: 40.sp),
        //carosel text
        carousalSliderSection(),
        SizedBox(height: 20.sp),
        GestureDetector(
          onTap: () {
            setState(() {
              counter++;
              total++;
              // تعديل القيمة في الأوبجكت
              var currentItem = syphaBox.getAt(currentIndex)!;
              currentItem.counter = counter.toString();

              // السطر السحري اللي كان ناقصك (عشان يسيف فعلياً):
              syphaBox.putAt(currentIndex, currentItem);

              // سيف الإجمالي في الـ Prefs برضه عشان يثبت
              Prefs.saveData(key: 'الاجمالي', value: total);
            });
          },
          child: Container(
            width: 300.sp,
            height: 350.sp,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.imagesSebha),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 80.sp),

                /******** */
                Text(
                  selectedValue,
                  style: GoogleFonts.amiri(
                    fontSize: 36.sp,
                    color: Colors.white,
                  ),
                ),
                /****** */
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                  child: Text(
                    '$counter',
                    
                    key: ValueKey<int>(
                      counter,
                    ), // مهم جداً عشان يعرف إن الرقم اتغير
                    style: GoogleFonts.amiri(
                      fontSize: 30.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFeatures: [
                    // const FontFeature.tabularFigures(), // بيخلي الأرقام تحت بعضها لو في لستة
                    const FontFeature('arab'), // تفعيل خصائص الأرقام العربية
                  ],
                    ),
                  ),
                ),
               
              ],
            ),
          ),
        ),

        // Chose Sebha Name
        Row(
          children: [
            const Spacer(flex: 1),
            GestureDetector(
              onTap: () {
                log("Refresh");

                clearCounterData();
                printAllData();
                setState(() {});
              },
              child: Image.asset(
                Assets.imagesRefresh,
                width: 35.sp,
                color: Colors.white,
              ),
            ),
            const Spacer(flex: 5),
            GestureDetector(
              onTap: () {
                log("Reset");
                // syphaBox.getAt(currentIndex)!.historyCounter = '0';
                resetDialog(context);
              },
              child: Image.asset(
                Assets.imagesReset,
                width: 35.sp,
                color: Colors.white,
              ),
            ),
            const Spacer(flex: 1),
          ],
        ),
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
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Text(
                '$total',
                key: ValueKey<int>(
                  counter,
                ), // مهم جداً عشان يعرف إن الرقم اتغير
                style: GoogleFonts.amiri(
                  fontSize: 30.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFeatures: [
                    // const FontFeature.tabularFigures(), // بيخلي الأرقام تحت بعضها لو في لستة
                    const FontFeature('arab'), // تفعيل خصائص الأرقام العربية
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  CarouselSlider carousalSliderSection() {
    return CarouselSlider.builder(
      itemBuilder: (context, index, realIndex) => Text(
        syphaBox.getAt(index)!.name,
        style: GoogleFonts.amiri(fontSize: 36.sp, color: Colors.white),
      ),
      itemCount: 4,
      options: CarouselOptions(
        height: 50.sp,
        viewportFraction: 0.52,
        enlargeCenterPage: true,
        enlargeFactor: 0.5,
        initialPage: currentIndex,
        onPageChanged: (index, reason) {
          setState(() {
            currentIndex = index;
            selectedValue = syphaBox.getAt(index)!.name;
            counter = int.parse(syphaBox.getAt(index)!.counter);
          });
        },
        enableInfiniteScroll: true,
      ),
    );
  }

  Future<dynamic> resetDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("الارقام السابقة"),
          content: SizedBox(
            height: 100.sp,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: List.generate(4, (index) {
                      return Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: syphaBox.getAt(index)!.name),
                            const TextSpan(text: " : "),
                            TextSpan(
                              text: syphaBox.getAt(index)!.historyCounter,
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 2.sp,
                    indent: 50.sp,
                    endIndent: 50.sp,
                  ),
                  Text(
                    'الاجمالي : ${totalHistoryCounter()}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ////////////*************** */
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            TextButton(
              onPressed: () {
                clearHistoryData();

                Navigator.of(context).pop();
              },
              child: const Text("تنظيف"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("اغلاق"),
            ),
          ],
        );
      },
    );
  }

  void clearHistoryData() {
    for (int i = 0; i < syphaBox.length; i++) {
      var item = syphaBox.getAt(i)!;
      item.historyCounter = '0';
      syphaBox.putAt(i, item); // حفظ التعديل
    }
    totalHistory = 0;
    printAllData();
    setState(() {});
  }

  int totalCounter() {
    // int total = 0;
    for (var item in syphaBox.values) {
      total = total + int.parse(item.counter);
    }
    return total;
  }

  int totalHistoryCounter() {
    totalHistory = 0;
    for (var item in syphaBox.values) {
      totalHistory = totalHistory + int.parse(item.historyCounter);
    }
    return totalHistory;
  }

  void clearCounterData() {
    for (int i = 0; i < syphaBox.length; i++) {
      var item = syphaBox.getAt(i)!;
      item.historyCounter =
          (int.parse(item.historyCounter) + int.parse(item.counter)).toString();
      item.counter = '0';

      // لازم تخزن الأوبجكت بعد التعديل
      syphaBox.putAt(i, item);
    }
    total = 0;
    counter = 0;
    Prefs.saveData(key: 'total', value: total);
    setState(() {});
  }

  Future<void> openBox() async {
    syphaBox = Hive.box('SyphaBox');
    // syphaBox.clear();

    if (syphaBox.isEmpty) {
      // Initialize with default values if the box is empty

      syphaBox.addAll([
        LocalSypha(name: "سبحان الله", counter: '0', historyCounter: '0'),
        LocalSypha(name: "الحمد لله", counter: '0', historyCounter: '0'),
        LocalSypha(name: "لا إله إلا الله", counter: '0', historyCounter: '0'),
        LocalSypha(name: "الله أكبر", counter: '0', historyCounter: '0'),
        LocalSypha(name: 'استغفر الله', counter: '0', historyCounter: '0'),
      ]);
    }

    // Print all data in the syphaBox
    // printAllData();
    setState(() {});
  }

  void printAllData() {
    // Iterate through all the items in the syphaBox
    for (var item in syphaBox.values) {
      print(item.toString()); // Print each item's data
      // syphaBox.getAt(0)!.historyCounter = '20';
      print('Name: ${item.name}');
      print('Counter: ${item.counter}');
      print('History Counter: ${item.historyCounter}');
    }
  }
}
