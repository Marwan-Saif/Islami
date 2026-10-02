import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami/features/Quran/data/models/surah_model.dart';
import 'package:islami/features/Quran/domain/quran_repo.dart';

part 'quran_state.dart';

class QuranCubit extends Cubit<QuranState> {
  QuranCubit(this.quranRepo) : super(QuranInitial());
  final QuranRepo quranRepo;
  QuranModel? _fullQuran;

  void getQuran() {
    log('in quran cubit *********');
    emit(GetQuranLoading());
    // quranRepo.getQuranData();
    quranRepo.getQuranData().then((quranModel) {
      log('length is  ${quranModel.data!.length}');
      log('in quran cubit 88888888888');
      _fullQuran = quranModel;
      emit(GetQuranSuccess(quranModel));
    }).catchError((error) {
      log('error is $error');
      emit(GetQuranError(error.toString()));
    });
  }

  /// بحث باسم السورة (عربي من غير تشكيل أو إنجليزي) أو برقمها
  void search(String query) {
    final surahs = _fullQuran?.data;
    if (surahs == null) return;
    final arabicQuery = _normalizeArabic(query);
    final englishQuery = _normalizeEnglish(query);
    final number = int.tryParse(query.trim());

    if (number == null && arabicQuery.isEmpty && englishQuery.isEmpty) {
      emit(GetQuranSuccess(_fullQuran!));
      return;
    }
    emit(GetQuranSuccess(QuranModel(
      data: surahs.where((surah) {
        if (number != null) return surah.number == number;
        return (arabicQuery.isNotEmpty &&
                _normalizeArabic(surah.name ?? '').contains(arabicQuery)) ||
            (englishQuery.isNotEmpty &&
                _normalizeEnglish(surah.englishName ?? '').contains(englishQuery));
      }).toList(),
    )));
  }

  // بيشيل التشكيل وكلمة "سورة" وبيوحد أشكال الألف والتاء المربوطة
  String _normalizeArabic(String text) => text
      .replaceAll(RegExp('[ؐ-ًؚ-ٰٟۖ-ۭـ]'), '')
      .replaceAll('سورة', '')
      .replaceAll(RegExp('[أإآٱ]'), 'ا')
      .replaceAll('ة', 'ه')
      .replaceAll('ى', 'ي')
      .replaceAll(RegExp(r'[^ء-ي]'), '');

  String _normalizeEnglish(String text) =>
      text.toLowerCase().replaceAll(RegExp('[^a-z]'), '');
}
