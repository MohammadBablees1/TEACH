part of 'animated_container_tow_cubit.dart';

@immutable
sealed class AnimatedContainerTowState {}

final class AnimatedContainerTowInitial extends AnimatedContainerTowState {}

class ChangeAnimation extends AnimatedContainerTowState {
  var manager = true;
  var codes = false;
  ChangeAnimation({required this.manager, required this.codes});
}
