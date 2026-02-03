import 'package:hive/hive.dart';
import 'package:islami/hive_helper/hive_types.dart';
import 'package:islami/hive_helper/hive_adapters.dart';
import 'package:islami/hive_helper/fields/zekr_local_data_moel_fields.dart';


part 'zekr_localdata.g.dart';


@HiveType(typeId: HiveTypes.zekrLocalDataMoel, adapterName: HiveAdapters.zekrLocalDataMoel)
class ZekrLocalDataMoel extends HiveObject{
	@HiveField(ZekrLocalDataMoelFields.zekrName)
  final String zekrName;
	@HiveField(ZekrLocalDataMoelFields.zekrBody)
  final String zekrBody;
	@HiveField(ZekrLocalDataMoelFields.zekrtime)
  final String zekrtime;
	@HiveField(ZekrLocalDataMoelFields.zekrAllawed)
  final bool zekrAllawed;

  ZekrLocalDataMoel({required this.zekrName, required this.zekrBody, required this.zekrtime, required this.zekrAllawed});
}