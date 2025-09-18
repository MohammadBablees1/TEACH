part of 'color_me_cubit.dart';

@immutable
sealed class ColorMeState {}

final class ColorMeInitial extends ColorMeState {}

final class SelectMe extends ColorMeState {
  List selected = [];
  SelectMe({required this.selected});
}

final class ResetMe extends ColorMeState {
  
}
