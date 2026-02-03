import 'package:islami/features/Timer/domain/zekr_entity.dart';

abstract class ZekrRepo{

  Future<List<List<ZekrEntity>>> getZekrList();
  
}