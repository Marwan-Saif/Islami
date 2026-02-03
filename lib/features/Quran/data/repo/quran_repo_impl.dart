import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:islami/features/Quran/data/models/surah_model.dart';
import 'package:islami/features/Quran/domain/quran_repo.dart';

class QuranRepoImpl implements QuranRepo {
  @override
  Future <QuranModel> getQuranData() async{
    log('Getting Zekr List');
    try {
      
        String jsonString = await rootBundle.loadString('assets/data/quran.json');
        dynamic jsonData = json.decode(jsonString);
      return QuranModel.fromJson(jsonData);
    } catch (e) {
      print("Error reading JSON file: $e");
    }
    return QuranModel.fromJson({});
  }

}