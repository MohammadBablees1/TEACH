part of 'clauser_index_cubit.dart';

@immutable
sealed class ClauserIndexState {}

final class ClauserIndexInitial extends ClauserIndexState {}
class ChangeIndex extends ClauserIndexState {
  var newIndex = 0;
  ChangeIndex({required this.newIndex});
  
}

