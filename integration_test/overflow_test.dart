// UI audit: opens every screen, sheet and dialog of the app on several
// screen sizes, font scales and both languages, and reports every layout
// overflow (the yellow/black stripes) with the screen it happened on.
//
//   flutter test integration_test/overflow_test.dart -d <device>
//
// Screens that need the network (hadith texts, reciters list) are visited
// too, so run it with internet for full coverage.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:integration_test/integration_test.dart';
import 'package:islami/core/helper_functions/app_router.dart';
import 'package:islami/core/services/app_settings.dart';
import 'package:islami/core/services/audio_services.dart';
import 'package:islami/core/services/get_it.dart';
import 'package:islami/core/utils/app_images.dart';
import 'package:islami/features/Quran/domain/quran_repo.dart';
import 'package:islami/features/Quran/presentation/views/surah_view.dart';
import 'package:islami/features/Quran/presentation/views/widgets/ayah_actions_sheet.dart';
import 'package:islami/features/Quran/presentation/views/widgets/surah_body.dart';
import 'package:islami/features/Radio/domain/recitations_repo.dart';
import 'package:islami/features/Radio/presentation/views/reciters_view.dart';
import 'package:islami/features/Timer/presentation/views/widgets/azkar_card.dart';
import 'package:islami/features/Timer/presentation/views/widgets/zekr_card.dart';
import 'package:islami/features/home/presentation/views/widgets/bottom_nav_item.dart';
import 'package:islami/generated/l10n.dart';
import 'package:islami/constants.dart';
import 'package:islami/main.dart' as app;

class _Config {
  const _Config(this.name, this.size, this.pixelRatio, this.textScale);
  final String name;
  final Size size; // logical pixels
  final double pixelRatio;
  final double textScale;
}

const _configs = [
  _Config('small 320x568', Size(320, 568), 2, 1.0),
  _Config('small 320x568 font 1.3', Size(320, 568), 2, 1.3),
  _Config('phone 360x640 font 1.3', Size(360, 640), 3, 1.3),
  _Config('phone 393x873', Size(393, 873), 2.75, 1.0),
  _Config('phone 393x873 font 1.3', Size(393, 873), 2.75, 1.3),
];

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('no layout overflows on any screen', (tester) async {
    final problems = <String>{};
    var where = '';

    Future<void> frames([int milliseconds = 900]) async {
      final end = DateTime.now().add(Duration(milliseconds: milliseconds));
      while (DateTime.now().isBefore(end)) {
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    Future<void> waitFor(Finder finder, {int seconds = 20}) async {
      final end = DateTime.now().add(Duration(seconds: seconds));
      while (finder.evaluate().isEmpty && DateTime.now().isBefore(end)) {
        await tester.pump(const Duration(milliseconds: 100));
      }
    }

    // بيعمل scroll للقايمة اللي على الشاشة لحد ما العنصر يتبني ويظهر
    Future<void> reveal(Finder finder) async {
      for (int i = 0; i < 20 && finder.evaluate().isEmpty; i++) {
        final scrollables = find.byType(Scrollable).hitTestable();
        if (scrollables.evaluate().isEmpty) break;
        await tester.drag(scrollables.first, const Offset(0, -250),
            warnIfMissed: false);
        await frames(250);
      }
      if (finder.evaluate().isNotEmpty) {
        await tester.ensureVisible(finder.first);
        await frames(250);
      }
    }

    Future<void> tapIfPresent(Finder finder) async {
      await reveal(finder);
      if (finder.evaluate().isEmpty) {
        problems.add('$where: could not find $finder');
        return;
      }
      await tester.tap(finder.first, warnIfMissed: false);
      await frames();
    }

    void closeSheet() {
      final sheets = find.byType(BottomSheet);
      if (sheets.evaluate().isNotEmpty) {
        Navigator.of(tester.element(sheets.last)).pop();
      }
    }

    Future<void> home() async {
      // الـ dialogs والـ sheets مش صفحات في الراوتر، فبتتقفل الأول
      for (final type in [Dialog, AlertDialog, BottomSheet]) {
        while (find.byType(type).evaluate().isNotEmpty) {
          Navigator.of(tester.element(find.byType(type).last)).pop();
          await frames(300);
        }
      }
      AppRouter.router.go(AppRouter.homeView);
      await frames(600);
    }

    Future<void> open(String route, {Object? extra}) async {
      unawaited(AppRouter.router.push(route, extra: extra));
      await frames();
    }

    // أول تشغيل بيفتح الـ onboarding، والتيست بيبدأ من الرئيسية
    await (await SharedPreferences.getInstance()).setBool(kOnboardingSeenKey, true);
    app.main();
    await waitFor(find.byType(BottomNavItem), seconds: 60);

    // تسجيل الـ overflow بدل ما يوقف التيست، مع اسم الشاشة والـ widget
    final previousOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      final text = details.toString();
      final widgetLine = RegExp(r'The relevant error-causing widget was:\s*\n\s*(.+)')
          .firstMatch(text)
          ?.group(1)
          ?.trim();
      final first = details.exceptionAsString().split('\n').first;
      problems.add('$where: $first  <- ${widgetLine ?? '?'}');
    };

    try {
      for (final language in ['ar', 'en']) {
        await AppSettings.instance.setLanguage(language);
        await frames();
        for (final config in _configs) {
          tester.view.devicePixelRatio = config.pixelRatio;
          tester.view.physicalSize = config.size * config.pixelRatio;
          tester.platformDispatcher.textScaleFactorTestValue = config.textScale;
          final s = S.current;
          String at(String screen) => where = '[$language ${config.name}] $screen';

          at('splash');
          AppRouter.router.go('/');
          await frames(1800);
          await waitFor(find.byType(BottomNavItem));

          at('onboarding');
          await open(AppRouter.onBoardingView);
          await home();

          for (final (index, name) in [
            (2, 'home'),
            (1, 'quran tab'),
            (0, 'radio tab'),
            (3, 'tasbih tab'),
            (4, 'qibla tab'),
          ]) {
            at(name);
            await tester.tap(find.byType(BottomNavItem).at(index));
            await frames();
          }

          at('tasbih history dialog');
          await tester.tap(find.byType(BottomNavItem).at(3));
          await frames();
          await tapIfPresent(find.image(const AssetImage(Assets.imagesReset)));
          await home();

          at('azkar screen');
          await tester.tap(find.byType(BottomNavItem).at(2));
          await frames();
          await tapIfPresent(find.byType(ZekrCard));
          at('zekr details');
          await tapIfPresent(find.byType(AZkarCard));
          await home();

          at('settings');
          await open(AppRouter.settingsView);
          for (final (sheet, label) in [
            ('settings method sheet', s.calculationMethod),
            ('settings location sheet', s.location),
            ('settings reciter sheet', s.defaultAyahReciter),
          ]) {
            at(sheet);
            await tapIfPresent(find.text(label));
            closeSheet();
            await frames(400);
          }
          await home();

          at('reading tracker');
          await open(AppRouter.readingTrackerView);
          at('reading tracker goal sheet');
          await tapIfPresent(find.text(s.editGoal));
          await home();
          at('reading tracker reset dialog');
          await open(AppRouter.readingTrackerView);
          await tapIfPresent(find.text(s.startNewKhatma));
          await home();

          for (final translation in [false, true]) {
            await AppSettings.instance.setShowTranslation(translation);
            for (final fontSize in [AppSettings.minFontSize, AppSettings.maxFontSize]) {
              await AppSettings.instance.setQuranFontSize(fontSize);
              at('surah view (font $fontSize, translation $translation)');
              await open(AppRouter.surahScreen, extra: SurahScreenArgs(2));
              await home();
            }
          }
          await AppSettings.instance.setShowTranslation(false);
          await AppSettings.instance.setQuranFontSize(22);

          at('ayah sheet');
          await open(AppRouter.surahScreen, extra: SurahScreenArgs(2));
          final ayah = getit.get<QuranRepo>().getAyahs(2)[254];
          unawaited(showAyahActionsSheet(
            tester.element(find.byType(SurahBody)),
            surahNumber: 2,
            ayah: ayah,
          ));
          await frames();
          at('ayah sheet with tafsir');
          await tapIfPresent(find.text(s.tafsirMuyassar));
          at('ayah reciter picker');
          await tapIfPresent(find.byIcon(Icons.record_voice_over_rounded));
          await home();

          at('ayah search');
          await open(AppRouter.ayahSearchView, extra: 'الرحمن');
          await frames(1500);
          await home();

          at('hadith sections');
          await open(AppRouter.hadithSectionsView, extra: 'bukhari');
          await home();
          at('hadith list');
          await open(AppRouter.hadithListView, extra: (book: 'bukhari', section: 1));
          await frames(3000);
          await home();
          at('hadith favorites');
          await open(AppRouter.hadithFavoritesView);
          await home();

          at('reciters');
          await open(AppRouter.recitersView);
          await waitFor(find.byType(ReciterCard), seconds: 15);
          at('rewaya sheet');
          await tapIfPresent(find.descendant(
            of: find.byType(ReciterCard),
            matching: find.textContaining(RegExp('روايات|narrations')),
          ));
          await home();

          at('reciter surahs + mini player');
          await open(
            AppRouter.reciterSurahsView,
            extra: getit.get<RecitationsRepo>().getLastSelection(),
          );
          await tapIfPresent(find.text(s.playAll));
          await frames(2500);
          await AudioService().audioPlayer.stop();
          await home();
        }
      }
    } catch (e, stack) {
      problems.add('$where: test step failed: $e\n$stack');
    } finally {
      FlutterError.onError = previousOnError;
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.platformDispatcher.clearTextScaleFactorTestValue();
      await AppSettings.instance.setLanguage('ar');
    }

    // ignore: avoid_print
    print('UI AUDIT: ${problems.length} problems\n${problems.join('\n')}');
    expect(problems, isEmpty);
  });
}
