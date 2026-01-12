part of 'update_password_loading_cubit.dart';

@immutable
sealed class UpdatePasswordLoadingState {}

final class UpdatePasswordLoadingInitial extends UpdatePasswordLoadingState {}

final class UpdatePasswordLoading extends UpdatePasswordLoadingState {
  final bool loading;

  UpdatePasswordLoading({required this.loading});
}
