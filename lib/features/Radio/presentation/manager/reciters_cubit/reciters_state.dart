part of 'reciters_cubit.dart';

@immutable
sealed class RecitersState {}

final class RecitersInitial extends RecitersState {}

final class RecitersLoading extends RecitersState {}

final class RecitersSuccess extends RecitersState {
  final List<ReciterModel> reciters;
  RecitersSuccess({required this.reciters});
}

final class RecitersFailure extends RecitersState {
  final String errorMessage;
  RecitersFailure({required this.errorMessage});
}
