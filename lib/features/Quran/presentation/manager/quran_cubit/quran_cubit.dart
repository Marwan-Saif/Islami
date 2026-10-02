import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami/features/Quran/data/models/surah_model.dart';
import 'package:islami/features/Quran/domain/quran_repo.dart';

part 'quran_state.dart';

class QuranCubit extends Cubit<QuranState> {
  QuranCubit(this.quranRepo) : super(QuranInitial());
  final QuranRepo quranRepo;

  void getQuran() {
    log('in quran cubit *********');
    emit(GetQuranLoading());
    // quranRepo.getQuranData();
    quranRepo.getQuranData().then((quranModel) {
      log('length is  ${quranModel.data!.length}');
      log('in quran cubit 88888888888');
      emit(GetQuranSuccess(quranModel));
    }).catchError((error) {
      log('error is $error');
      emit(GetQuranError(error.toString()));
    });
  }
}
