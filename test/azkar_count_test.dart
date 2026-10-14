import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:islami/features/Timer/domain/zekr_entity.dart';

List<ZekrEntity> _load(String name) {
  final json = jsonDecode(File('assets/data/$name').readAsStringSync()) as List;
  return [for (final item in json) ZekrEntity.fromJson(item)];
}

void main() {
  test('every zekr has a repetition count of at least 1', () {
    for (final file in Directory('assets/data').listSync().whereType<File>()) {
      for (final zekr in _load(file.uri.pathSegments.last)) {
        expect(zekr.count, greaterThanOrEqualTo(1), reason: file.path);
      }
    }
  });

  test('morning azkar keep their known counts', () {
    final morning = _load('أذكار_الصباح.json');
    expect(morning.first.count, 1); // آية الكرسي
    expect(morning[1].count, 3); // الإخلاص
    expect(morning.last.count, 100); // أستغفر الله وأتوب إليه
  });

  test('a missing or invalid count falls back to once', () {
    expect(ZekrEntity.fromJson({'hint': '', 'text': ''}).count, 1);
    expect(ZekrEntity.fromJson({'number': 0, 'hint': '', 'text': ''}).count, 1);
  });
}
