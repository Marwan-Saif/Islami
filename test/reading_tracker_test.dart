import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:islami/features/Quran/data/reading_tracker.dart';

void main() {
  late Directory dir;
  final tracker = ReadingTracker.instance;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('reading_tracker_test');
    Hive.init(dir.path);
    await Hive.openBox(ReadingTracker.boxName);
  });

  tearDown(() async {
    await Hive.deleteBoxFromDisk(ReadingTracker.boxName);
    await dir.delete(recursive: true);
  });

  test('pages are counted once for the khatma and for today', () async {
    await tracker.markPageRead(1);
    await tracker.markPageRead(2);
    await tracker.markPageRead(2);
    expect(tracker.khatmaPages, {1, 2});
    expect(tracker.todayPages, 2);
    expect(tracker.streak, 1);
    expect(tracker.khatmaProgress, closeTo(2 / 604, 1e-9));
  });

  test('reading all 604 pages completes a khatma and starts a new one', () async {
    bool completed = false;
    for (int page = 1; page <= ReadingTracker.totalPages; page++) {
      completed = await tracker.markPageRead(page);
    }
    expect(completed, isTrue);
    expect(tracker.completedKhatmas, 1);
    expect(tracker.khatmaPages, isEmpty);
  });

  test('bookmarks toggle and last read is saved', () async {
    const position = ReadingPosition(surah: 2, ayah: 255, page: 42);
    expect(await tracker.toggleBookmark(position), isTrue);
    expect(tracker.isBookmarked(2, 255), isTrue);
    expect(await tracker.toggleBookmark(position), isFalse);
    expect(tracker.bookmarks, isEmpty);

    await tracker.saveLastRead(position);
    expect(tracker.lastRead?.ayah, 255);
  });

  test('daily goal defaults to 5 and can be changed', () async {
    expect(tracker.dailyGoal, 5);
    await tracker.setDailyGoal(20);
    expect(tracker.dailyGoal, 20);
  });
}
