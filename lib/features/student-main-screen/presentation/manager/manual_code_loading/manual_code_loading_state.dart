part of 'manual_code_loading_cubit.dart';

@immutable
sealed class ManualCodeLoadingState {}

final class ManualCodeLoadingInitial extends ManualCodeLoadingState {}

final class ManualCodeLoading extends ManualCodeLoadingState {
  final bool loading;
  ManualCodeLoading({required this.loading});
}
