import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:islami/constants.dart';
import 'package:islami/features/Timer/domain/zekr_entity.dart';
import 'package:islami/features/Timer/domain/zekr_repo.dart';

class ZekrRepoImpl extends ZekrRepo {
  List<List<ZekrEntity>> AzkarList = [];
  @override
  Future<List<List<ZekrEntity>>> getZekrList() async {
    log('Getting Zekr List');
    try {
      for (var file in kFiles) {
        String jsonString = await rootBundle.loadString(file);
        List<dynamic> jsonData = json.decode(jsonString);

        // log(jsonData.toString());
        AzkarList.add([for (var item in jsonData) ZekrEntity.fromJson(item)]);
      }
      return AzkarList;
    } catch (e) {
      print("Error reading JSON file: $e");
    }
    return [];
  }
}
