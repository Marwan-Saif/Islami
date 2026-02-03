import 'package:hive/hive.dart';
import 'package:islami/features/Sebha/presentation/views/local_sypha.dart';
import 'package:islami/features/Timer/data/hive/zekr_localdata.dart';

void registerAdapters() {
	Hive.registerAdapter(LocalSyphaAdapter());
	Hive.registerAdapter(ZekrLocalDataMoelAdapter());
}
