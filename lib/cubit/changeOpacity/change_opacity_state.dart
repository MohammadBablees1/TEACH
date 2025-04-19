part of 'change_opacity_cubit.dart';

@immutable
sealed class ChangeOpacityState {}

final class ChangeOpacityInitial extends ChangeOpacityState {}

class ChangeOpacity extends ChangeOpacityState {
  double opacity = 0;
  
  ChangeOpacity({required this.opacity});
}
