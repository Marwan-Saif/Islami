import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class ReadingPosition {
  const ReadingPosition({required this.surah, required this.ayah, required this.page});
  final int surah;
  final int ayah;
  final int page;
}

/// متابعة التلاوة: آخر قراءة، الختمة (صفحات المصحف)، الورد اليومي، والعلامات.
/// كله متخزن في Hive box عادي من غير adapters (lists و maps بس)
class ReadingTracker {
  ReadingTracker._();
  static final ReadingTracker instance = ReadingTracker._();

  static const String boxName = 'reading_progress';
  static const int totalPages = 604;

  Box get _box => Hive.box(boxName);

  /// بيزيد مع أي تغيير عشان الكروت اللي بتعرض التقدم تتحدث
  final ValueNotifier<int> changes = ValueNotifier(0);
  void _notify() => changes.value++;

  // ---------- آخر قراءة ----------
  ReadingPosition? get lastRead {
    final Map? data = _box.get('last_read');
    if (data == null) return null;
    return ReadingPosition(
        surah: data['surah'], ayah: data['ayah'], page: data['page']);
  }

  Future<void> saveLastRead(ReadingPosition position) async {
    await _box.put('last_read', {
      'surah': position.surah,
      'ayah': position.ayah,
      'page': position.page,
    });
    _notify();
  }

  // ---------- الختمة ----------
  Set<int> get khatmaPages =>
      Set<int>.from(_box.get('khatma_pages', defaultValue: const <int>[]) as List);

  int get completedKhatmas => _box.get('khatmas_completed', defaultValue: 0);

  double get khatmaProgress => khatmaPages.length / totalPages;

  /// بترجع true لو الصفحة دي كملت ختمة جديدة
  Future<bool> markPageRead(int page) async {
    bool completed = false;
    final pages = khatmaPages;
    if (pages.add(page)) {
      if (pages.length >= totalPages) {
        await _box.put('khatmas_completed', completedKhatmas + 1);
        pages.clear();
        completed = true;
      }
      await _box.put('khatma_pages', pages.toList());
    }

    final todayKey = _dayKey(DateTime.now());
    final today = Set<int>.from(_box.get(todayKey, defaultValue: const <int>[]) as List);
    if (today.add(page)) await _box.put(todayKey, today.toList());

    _notify();
    return completed;
  }

  Future<void> resetKhatma() async {
    await _box.put('khatma_pages', <int>[]);
    _notify();
  }

  // ---------- الورد اليومي ----------
  int get dailyGoal => _box.get('daily_goal', defaultValue: 5);

  Future<void> setDailyGoal(int pages) async {
    await _box.put('daily_goal', pages);
    _notify();
  }

  int pagesReadOn(DateTime day) =>
      (_box.get(_dayKey(day), defaultValue: const <int>[]) as List).length;

  int get todayPages => pagesReadOn(DateTime.now());

  /// عدد الأيام المتتالية اللي فيها قراءة (النهارده مش لازم يكون اتقرا لسه)
  int get streak {
    var day = DateTime.now();
    if (pagesReadOn(day) == 0) day = day.subtract(const Duration(days: 1));
    int count = 0;
    while (pagesReadOn(day) > 0) {
      count++;
      day = day.subtract(const Duration(days: 1));
    }
    return count;
  }

  String _dayKey(DateTime day) =>
      'day_${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';

  // ---------- العلامات ----------
  List<ReadingPosition> get bookmarks => [
        for (final Map item
            in _box.get('bookmarks', defaultValue: const <Map>[]) as List)
          ReadingPosition(surah: item['surah'], ayah: item['ayah'], page: item['page']),
      ];

  bool isBookmarked(int surah, int ayah) =>
      bookmarks.any((b) => b.surah == surah && b.ayah == ayah);

  /// بترجع true لو اتضافت، false لو اتشالت
  Future<bool> toggleBookmark(ReadingPosition position) async {
    final list = bookmarks;
    final exists = list.indexWhere(
        (b) => b.surah == position.surah && b.ayah == position.ayah);
    if (exists >= 0) {
      list.removeAt(exists);
    } else {
      list.insert(0, position);
    }
    await _box.put('bookmarks', [
      for (final b in list) {'surah': b.surah, 'ayah': b.ayah, 'page': b.page},
    ]);
    _notify();
    return exists < 0;
  }
}
