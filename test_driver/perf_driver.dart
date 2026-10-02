import 'package:flutter_driver/flutter_driver.dart' as driver;
import 'package:integration_test/integration_test_driver.dart';

/// Saves a timeline summary for every reportKey of integration_test/perf_test.dart
Future<void> main() {
  return integrationDriver(
    responseDataCallback: (data) async {
      if (data == null) return;
      for (final key in data.keys) {
        if (!key.startsWith('perf_')) continue;
        final timeline = driver.Timeline.fromJson(data[key] as Map<String, dynamic>);
        final summary = driver.TimelineSummary.summarize(timeline);
        await summary.writeTimelineToFile(key, pretty: true, includeSummary: true);
      }
      await writeResponseData(
        {'time_to_home_ms': data['time_to_home_ms']},
        testOutputFilename: 'perf_extra',
      );
    },
  );
}
