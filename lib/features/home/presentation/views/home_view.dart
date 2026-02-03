import 'package:flutter/material.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/utils/app_images.dart';
import 'package:islami/features/Qibla/presentation/views/qibla_view.dart';
import 'package:islami/features/Quran/presentation/views/quran_view.dart';
import 'package:islami/features/Radio/presentation/views/radio_view.dart';
import 'package:islami/features/Sebha/presentation/views/sebha_view.dart';
import 'package:islami/features/Timer/presentation/views/timer_view.dart';
import 'package:islami/features/home/presentation/views/widgets/custom_bottom_navbar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultScreen();
  }
}

class DefaultScreen extends StatefulWidget {
  DefaultScreen({
    super.key,
  });

  @override
  State<DefaultScreen> createState() => _DefaultScreenState();
}

class _DefaultScreenState extends State<DefaultScreen> {
  int currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //background
        Image.asset(
          Assets.imagesTajMahalAgraIndia,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        //scaffold
        Positioned(
          child: Scaffold(
            backgroundColor: AppColors.backgroundColor.withAlpha(150),
            body: IndexedStack(
              index: currentIndex,
              children: [
                QuranView(),

                // AudioPlayerScreen(),
                QuranView(),
                TimerView(),
                SebhaView(),
                // SebhaView(),
                QiblaScreen()
              ],
            ),
            bottomNavigationBar: CustomBottomNaBar(
              currentIndex: (index) {
                currentIndex = index;
                setState(() {});
              },
            ),
          ),
        ),
      ],
    );
  }
}
