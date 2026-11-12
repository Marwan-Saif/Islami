import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:islami/constants.dart';
import 'package:islami/features/Timer/domain/zekr_entity.dart';
import 'package:islami/features/Timer/domain/zekr_repo.dart';

class ZekrRepoImpl extends ZekrRepo {
  @override
  Future<List<List<ZekrEntity>>> getZekrList() async {
    log('Getting Zekr List');
    // list جديدة مع كل تحميل، عشان التحميل التاني ميكررش الأذكار
    final List<List<ZekrEntity>> azkarList = [];
    try {
      for (var file in kFiles) {
        String jsonString = await rootBundle.loadString(file);
        List<dynamic> jsonData = json.decode(jsonString);

        // log(jsonData.toString());
        azkarList.add([for (var item in jsonData) ZekrEntity.fromJson(item)]);
      }
      return azkarList;
    } catch (e) {
      log("Error reading JSON file: $e");
    }
    return [];
  }
}
