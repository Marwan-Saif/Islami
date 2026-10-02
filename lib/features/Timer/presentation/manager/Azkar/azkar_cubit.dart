import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:islami/constants.dart';
import 'package:islami/features/Timer/data/azkar_notifications.dart';
import 'package:islami/features/Timer/data/hive/zekr_localdata.dart';
import 'package:islami/features/Timer/domain/zekr_entity.dart';
import 'package:islami/features/Timer/domain/zekr_repo.dart';

part 'azkar_state.dart';

class AzkarCubit extends Cubit<AzkarState> {
  final ZekrRepo zekrRepo;
  AzkarCubit(this.zekrRepo) : super(AzkarInitial());
  late Box<ZekrLocalDataMoel> azkarBox;
  List<ZekrLocalDataMoel> azkarLocalDataList = [];

  Future<void> getAzkar() async {
    emit(LoadingAzkar());
    try {
      List<List<ZekrEntity>> zekrList = await zekrRepo.getZekrList();
      emit(AzkarLoadedSuccessfuly(zekrList: zekrList));
    } catch (e) {
      emit(ErrorAzkar(errorMessage: e.toString()));
    }
  }

  Future<void> getAzkarLocalData() async {
    emit(LocalAzkarDataLoading());
    azkarBox = Hive.box(kZekrBox);
    if (azkarBox.isEmpty) {
      azkarBox.clear();
      log("empty box at azkar cubit");
      azkarBox.put(0, kAzkarData[0]);

      azkarBox.put(1, kAzkarData[1]);
    }
    azkarLocalDataList
      ..clear()
      ..addAll(azkarBox.values);
    // الجدولة بتحصل مع فتح الأبلكيشن (main) ومع أي تعديل في updatelocalData
    emit(LocalAzkarDataLoaded());
    log("data adeed");
    printt();
  }

  void getlocalData() async {
    emit(GetLocalDataLoading());
    azkarBox = await Hive.openBox<ZekrLocalDataMoel>(kZekrBox);
    azkarLocalDataList
      ..clear()
      ..addAll(azkarBox.values);

    emit(GetLocalDataSuccess());
    printt();
  }

  void updatelocalData({required int index, String? time, bool? allowed}) {
    emit(UpDateLocalData());
    ZekrLocalDataMoel oldone = azkarBox.getAt(index)!;
    log(oldone.toString());
    final updateZekr = ZekrLocalDataMoel(
        zekrName: oldone.zekrName,
        zekrBody: oldone.zekrBody,
        zekrtime: time ?? oldone.zekrtime,
        zekrAllawed: allowed ?? oldone.zekrAllawed);
    azkarBox.putAt(index, updateZekr);
    azkarLocalDataList.clear();
    azkarLocalDataList.addAll(azkarBox.values);
    addNotifications();
    emit(LocalDataUpdated());
    // azkarLocalDataList.elementAt(id). = time;
    printt();
  }

  void printt() {
    log("in azkar Cubit \n ${azkarBox.getAt(0)!.zekrName} \n ${azkarBox.getAt(0)!.zekrtime} \n${azkarBox.getAt(0)!.zekrtime}\n${azkarBox.getAt(0)!.zekrAllawed}");
    log("in azkar Cubit \n ${azkarLocalDataList[1].zekrName} \n ${azkarLocalDataList[1].zekrtime} \n${azkarLocalDataList[1].zekrtime} \n${azkarLocalDataList[1].zekrAllawed}");
  }

  void addNotifications() {
    AzkarNotifications.schedule(azkarLocalDataList);
  }
}
