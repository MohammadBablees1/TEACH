part of 'sign_in_loading_cubit.dart';

@immutable
sealed class SignInLoadingState {}

final class SignInLoadingInitial extends SignInLoadingState {}

final class SignInLoading extends SignInLoadingState {
  final bool loading;
  SignInLoading({required this.loading});
}
