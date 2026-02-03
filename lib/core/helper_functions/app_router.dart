import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:islami/features/Quran/data/models/surah_model.dart';
import 'package:islami/features/Quran/presentation/views/surah_view.dart';
import 'package:islami/features/Sebha/presentation/views/test.dart';
import 'package:islami/features/Timer/domain/zekr_entity.dart';
import 'package:islami/features/Timer/presentation/views/zekr_view.dart';
import 'package:islami/features/home/presentation/views/home_view.dart';
import 'package:islami/core/widgets/sura.dart';
import 'package:islami/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:islami/features/splash/presentation/views/splash_view.dart';

abstract class AppRouter {
  static const String splashView = '/splashView';
  static const String onBoardingView = '/onBoardingView';
  static const String homeView = '/homeView';
  static const String suoraSCreen = '/suoraSCreen';
  static const String zekrScreen = '/zekrScreen';
  static const String test = '/test';

  static const String surahScreen = '/surahScreen';

  // static const String signupView = '/signupView';

  static final router = GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: onBoardingView,
      builder: (context, state) => const OnBoardingView(),
    ),
    GoRoute(
      path: homeView,
      builder: (context, state) => const HomeView(),
    ),
    GoRoute(
      path: suoraSCreen,
      builder: (context, state) => SuraSCreen(
        txt: state.extra as List<String>,
      ),
    ),
    GoRoute(
        path: zekrScreen,
        builder: (context, state) {
          final Map<String, dynamic> args = state.extra as Map<String, dynamic>;
          return ZekrView(
            azkarList: args["azkarList"] as List<ZekrEntity>,
            title: args["title"],
          );
        }),
    GoRoute(
      path: test,
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: surahScreen,
      builder: (context, state) => SurahScreen(
        ayahs: state.extra as List<Ayahs>,
      ),
    ),
    // GoRoute(
    //   path: signupView,
  ]);
}
