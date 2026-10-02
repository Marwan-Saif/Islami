// Performance benchmark: run on a real device (or emulator) in profile mode
//
//   flutter drive --profile --driver=test_driver/perf_driver.dart \
//     --target=integration_test/perf_test.dart
//
// writes build/perf_*.timeline_summary.json with frame build/raster times
// and the number of frames that missed the 16ms budget.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:islami/features/Quran/presentation/views/widgets/sura_card.dart';
import 'package:islami/features/home/presentation/views/widgets/bottom_nav_item.dart';
import 'package:islami/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpFor(WidgetTester tester, Duration duration) async {
    final end = DateTime.now().add(duration);
    while (DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 16));
    }
  }

  Future<void> waitFor(WidgetTester tester, Finder finder,
      {Duration timeout = const Duration(seconds: 60)}) async {
    final end = DateTime.now().add(timeout);
    while (finder.evaluate().isEmpty) {
      if (DateTime.now().isAfter(end)) {
        throw TimeoutException('timed out waiting for $finder');
      }
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  // bottom nav order: radio, quran, home, tasbih, qibla
  Future<void> openTab(WidgetTester tester, int index) async {
    await tester.tap(find.byType(BottomNavItem).at(index));
    await pumpFor(tester, const Duration(milliseconds: 800));
  }

  // one test: main() can only run once per process (get_it, hive, audio service)
  testWidgets('startup, navigation and scrolling', (tester) async {
    final stopwatch = Stopwatch()..start();
    await binding.traceAction(() async {
      app.main();
      await waitFor(tester, find.byType(BottomNavItem));
      binding.reportData = {
        ...?binding.reportData,
        'time_to_home_ms': stopwatch.elapsedMilliseconds,
      };
      // the first seconds after the home screen shows (notification
      // scheduling, prayer times, tab content) are part of the startup cost
      await pumpFor(tester, const Duration(seconds: 4));
    }, reportKey: 'perf_startup');

    await binding.traceAction(() async {
      for (final tab in [0, 1, 3, 4, 2]) {
        await openTab(tester, tab);
      }

      // quran list
      await openTab(tester, 1);
      final list = find.byType(SuraCard).first;
      for (int i = 0; i < 3; i++) {
        await tester.fling(list, const Offset(0, -600), 3000);
        await pumpFor(tester, const Duration(milliseconds: 800));
      }
      for (int i = 0; i < 3; i++) {
        await tester.fling(find.byType(SuraCard).first, const Offset(0, 600), 3000);
        await pumpFor(tester, const Duration(milliseconds: 800));
      }

      // the longest surah
      final baqara = find.byType(SuraCard).at(1);
      await tester.ensureVisible(baqara);
      await pumpFor(tester, const Duration(milliseconds: 500));
      await tester.tap(baqara);
      await waitFor(tester, find.byType(BackButton));
      await pumpFor(tester, const Duration(seconds: 2));
      final scrollable = find.byType(Scrollable).last;
      for (int i = 0; i < 4; i++) {
        await tester.fling(scrollable, const Offset(0, -700), 4000);
        await pumpFor(tester, const Duration(milliseconds: 800));
      }
      await tester.tap(find.byType(BackButton));
      await pumpFor(tester, const Duration(seconds: 1));
      await openTab(tester, 2);
    }, reportKey: 'perf_navigation');
  });
}

class TimeoutException implements Exception {
  TimeoutException(this.message);
  final String message;
  @override
  String toString() => message;
}
