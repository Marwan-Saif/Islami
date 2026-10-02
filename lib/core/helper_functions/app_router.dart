import 'package:go_router/go_router.dart';
import 'package:islami/features/Hadith/presentation/views/hadith_list_view.dart';
import 'package:islami/features/Hadith/presentation/views/hadith_sections_view.dart';
import 'package:islami/features/Quran/presentation/views/ayah_search_view.dart';
import 'package:islami/features/Quran/presentation/views/reading_tracker_view.dart';
import 'package:islami/features/Quran/presentation/views/surah_view.dart';
import 'package:islami/features/Radio/data/models/reciter_model.dart';
import 'package:islami/features/Radio/presentation/views/reciter_surahs_view.dart';
import 'package:islami/features/Radio/presentation/views/reciters_view.dart';
import 'package:islami/features/Sebha/presentation/views/test.dart';
import 'package:islami/features/Timer/domain/zekr_entity.dart';
import 'package:islami/features/Timer/presentation/views/zekr_view.dart';
import 'package:islami/features/home/presentation/views/home_view.dart';
import 'package:islami/core/widgets/sura.dart';
import 'package:islami/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:islami/features/settings/presentation/views/settings_view.dart';
import 'package:islami/features/splash/presentation/views/splash_view.dart';

abstract class AppRouter {
  static const String splashView = '/splashView';
  static const String onBoardingView = '/onBoardingView';
  static const String homeView = '/homeView';
  static const String suoraSCreen = '/suoraSCreen';
  static const String zekrScreen = '/zekrScreen';
  static const String test = '/test';

  static const String surahScreen = '/surahScreen';
  static const String ayahSearchView = '/ayahSearchView';
  static const String readingTrackerView = '/readingTrackerView';
  static const String settingsView = '/settingsView';
  static const String hadithSectionsView = '/hadithSectionsView';
  static const String hadithListView = '/hadithListView';
  static const String hadithFavoritesView = '/hadithFavoritesView';
  static const String recitersView = '/recitersView';
  static const String reciterSurahsView = '/reciterSurahsView';

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
      builder: (context, state) =>
          SurahScreen(args: state.extra as SurahScreenArgs),
    ),
    GoRoute(
      path: settingsView,
      builder: (context, state) => const SettingsView(),
    ),
    GoRoute(
      path: hadithSectionsView,
      builder: (context, state) =>
          HadithSectionsView(bookKey: state.extra as String),
    ),
    GoRoute(
      path: hadithListView,
      builder: (context, state) {
        final args = state.extra as ({String book, int section});
        return HadithListView(bookKey: args.book, sectionNumber: args.section);
      },
    ),
    GoRoute(
      path: hadithFavoritesView,
      builder: (context, state) => const HadithFavoritesView(),
    ),
    GoRoute(
      path: readingTrackerView,
      builder: (context, state) => const ReadingTrackerView(),
    ),
    GoRoute(
      path: ayahSearchView,
      builder: (context, state) =>
          AyahSearchView(query: state.extra as String),
    ),
    GoRoute(
      path: recitersView,
      builder: (context, state) => const RecitersView(),
    ),
    GoRoute(
      path: reciterSurahsView,
      builder: (context, state) {
        final selection =
            state.extra as ({ReciterModel reciter, MoshafModel moshaf});
        return ReciterSurahsView(
          reciter: selection.reciter,
          moshaf: selection.moshaf,
        );
      },
    ),
    // GoRoute(
    //   path: signupView,
  ]);
}
