part of 'login_password_visibility_cubit.dart';

@immutable
sealed class LoginPasswordVisibilityState {}

final class LoginPasswordVisibilityInitial
    extends LoginPasswordVisibilityState {}

final class LoginPasswordVisibility extends LoginPasswordVisibilityState {
  final bool isVisible;
  LoginPasswordVisibility({required this.isVisible});
}
