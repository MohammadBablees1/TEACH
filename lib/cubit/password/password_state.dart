part of 'password_cubit.dart';

@immutable
sealed class PasswordState {}

final class PasswordInitial extends PasswordState {}

class VisiblePassword extends PasswordState {
  var isVisible = false;
  VisiblePassword({required this.isVisible});
}

class FilePermisions extends PasswordState {
  var filePermision = false;
  var codePermesion = false;
  FilePermisions({required this.filePermision, required this.codePermesion});
}
