part of 'logout_loading_cubit.dart';

@immutable
sealed class LogoutLoadingState {}

final class LogoutLoadingInitial extends LogoutLoadingState {}

final class LogoutLoading extends LogoutLoadingState {
  final bool loading;
  LogoutLoading({required this.loading});
}
