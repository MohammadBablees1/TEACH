part of 'timer_cubit_cubit.dart';

@immutable
sealed class TimerCubitState {}

final class TimerCubitInitial extends TimerCubitState {}

class ChangeTime extends TimerCubitState {
  var timer = 0;
  ChangeTime({required this.timer});
}
