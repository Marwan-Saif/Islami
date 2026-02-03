import 'package:hive/hive.dart';
import 'package:islami/hive_helper/hive_types.dart';
import 'package:islami/hive_helper/hive_adapters.dart';
import 'package:islami/hive_helper/fields/local_sypha_fields.dart';


part 'local_sypha.g.dart';


@HiveType(typeId: HiveTypes.localSypha, adapterName: HiveAdapters.localSypha)
class LocalSypha extends HiveObject{
  
	@HiveField(LocalSyphaFields.name)
final  String name;
	@HiveField(LocalSyphaFields.counter)
  String counter;
	@HiveField(LocalSyphaFields.historyCounter)
 String historyCounter;

  LocalSypha({required this.name, required this.counter, required this.historyCounter});
}