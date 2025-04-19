part of 'code_changed_cubit.dart';

@immutable
sealed class CodeChangedState {}

final class CodeChangedInitial extends CodeChangedState {}

class ChangeCode extends CodeChangedState {
  var code = "";
  ChangeCode({required this.code});
}
