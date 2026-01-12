part of 'login_confirm_password_visibility_cubit.dart';

@immutable
sealed class LoginConfirmPasswordVisibilityState {}

final class LoginConfirmPasswordVisibilityInitial
    extends LoginConfirmPasswordVisibilityState {}

final class LoginConfirmPasswordVisibility
    extends LoginConfirmPasswordVisibilityState {
  final bool isVisible;

  LoginConfirmPasswordVisibility({required this.isVisible});
}
