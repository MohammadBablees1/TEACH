part of 'selected_value_cubit.dart';

@immutable
sealed class SelectedValueState {}

final class SelectedValueInitial extends SelectedValueState {}

final class SelectedValue extends SelectedValueState {
  var value = "";
  SelectedValue({required this.value});
}
