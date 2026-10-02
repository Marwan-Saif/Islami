import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami/features/Radio/data/models/reciter_model.dart';
import 'package:islami/features/Radio/domain/recitations_repo.dart';

part 'reciters_state.dart';

class RecitersCubit extends Cubit<RecitersState> {
  RecitersCubit(this.recitationsRepo) : super(RecitersInitial());
  final RecitationsRepo recitationsRepo;

  List<ReciterModel> _allReciters = [];

  Future<void> getReciters() async {
    emit(RecitersLoading());
    try {
      _allReciters = await recitationsRepo.getReciters();
      emit(RecitersSuccess(reciters: _allReciters));
    } catch (e) {
      emit(RecitersFailure(
          errorMessage: 'تعذر تحميل قائمة القراء، تأكد من الاتصال بالإنترنت'));
    }
  }

  void search(String query) {
    if (_allReciters.isEmpty) return;
    final normalized = _normalize(query);
    emit(RecitersSuccess(
      reciters: normalized.isEmpty
          ? _allReciters
          : _allReciters
              .where((reciter) => _normalize(reciter.name).contains(normalized))
              .toList(),
    ));
  }

  // عشان "عبد الباسط" تلاقي "عبدالباسط" و "احمد" تلاقي "أحمد"
  String _normalize(String text) => text
      .replaceAll(RegExp('[أإآ]'), 'ا')
      .replaceAll('ة', 'ه')
      .replaceAll('ى', 'ي')
      .replaceAll(' ', '')
      .trim();
}
