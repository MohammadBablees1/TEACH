part of 'current_password_visibility_cubit.dart';

@immutable
sealed class CurrentPasswordVisibilityState {}

final class CurrentPasswordVisibilityInitial
    extends CurrentPasswordVisibilityState {}

final class CurrentPasswordVisibility extends CurrentPasswordVisibilityState {
  final bool isVisible;
  CurrentPasswordVisibility({required this.isVisible});
}
