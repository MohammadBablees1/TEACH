part of 'teach_cubit.dart';

@immutable
sealed class TeachState {}

final class TeachInitial extends TeachState {}

class Connected extends TeachState {}

class NotConnected extends TeachState {}

class NoUSerFound extends TeachState {}
class UpdateApp extends TeachState {}

class UserFound extends TeachState {
  
 
}

class IsLoading extends TeachState {}

class SelectedAcount extends TeachState {
  var selected = 0;
  SelectedAcount({required this.selected});
}

class Percentage extends TeachState {
  var percent = 0.0;
  Percentage({required this.percent});
}


