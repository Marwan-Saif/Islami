part of 'quran_cubit.dart';

@immutable
sealed class QuranState {}

final class QuranInitial extends QuranState {}

final class GetQuranLoading  extends QuranState {}

final class GetQuranError extends QuranState {
  final String error;
  GetQuranError(this.error);
}

final class GetQuranSuccess extends QuranState {
  final QuranModel quranModel;
  GetQuranSuccess(this.quranModel);
}
