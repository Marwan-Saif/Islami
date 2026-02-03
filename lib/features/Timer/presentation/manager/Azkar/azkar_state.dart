part of 'azkar_cubit.dart';

@immutable
sealed class AzkarState {}

final class AzkarInitial extends AzkarState {}

final class LoadingAzkar extends AzkarState {}

final class AzkarLoadedSuccessfuly extends AzkarState {
  final List<List<ZekrEntity>> zekrList;

  AzkarLoadedSuccessfuly({required this.zekrList});
}

final class ErrorAzkar extends AzkarState {
  final String errorMessage;
  ErrorAzkar({required this.errorMessage});
}
final class LocalAzkarDataLoaded extends AzkarState {}

final class LocalAzkarDataLoading extends AzkarState {}

final class getlocalDataloading extends AzkarState {}
final class getlocalDatasuccess extends AzkarState {}
final class UpDateLocalData extends AzkarState {}
final class LocalDataUpdated extends AzkarState {}

