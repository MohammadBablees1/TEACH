part of 'selecte_class_cubit.dart';

@immutable
sealed class SelecteClassState {}

final class SelecteClassInitial extends SelecteClassState {}

final class SelecteClass extends SelecteClassState {
  var selectedClass = "";
  SelecteClass({required this.selectedClass});
}
