part of 'login_loading_cubit.dart';

@immutable
sealed class LoginLoadingState {}

final class LoginLoadingInitial extends LoginLoadingState {}

final class LoginLoading extends LoginLoadingState {
  final bool loading;
  LoginLoading({required this.loading});
}
