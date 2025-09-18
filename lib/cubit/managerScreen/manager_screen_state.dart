part of 'manager_screen_cubit.dart';

@immutable
sealed class ManagerScreenState {}

final class ManagerScreenInitial extends ManagerScreenState {}

final class Indexed extends ManagerScreenState {
  var currentIndex;
  Indexed({required this.currentIndex});
}
