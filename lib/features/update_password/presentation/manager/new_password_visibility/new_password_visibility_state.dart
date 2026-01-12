part of 'new_password_visibility_cubit.dart';

@immutable
sealed class NewPasswordVisibilityState {}

final class NewPasswordVisibilityInitial extends NewPasswordVisibilityState {}

final class NewPasswordVisibility extends NewPasswordVisibilityState {
  final bool isVisible;

  NewPasswordVisibility({required this.isVisible});
}
