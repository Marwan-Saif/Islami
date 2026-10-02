import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami/features/Radio/data/models/reciter_model.dart';
import 'package:islami/features/Radio/domain/recitations_repo.dart';
import 'package:islami/generated/l10n.dart';

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
      emit(RecitersFailure(errorMessage: S.current.recitersLoadError));
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
  // (والأسماء الإنجليزية من غير فرق بين الحروف الكبيرة والصغيرة)
  String _normalize(String text) => text
      .toLowerCase()
      .replaceAll(RegExp('[أإآ]'), 'ا')
      .replaceAll('ة', 'ه')
      .replaceAll('ى', 'ي')
      .replaceAll(' ', '')
      .trim();
}
