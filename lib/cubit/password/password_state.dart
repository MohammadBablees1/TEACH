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
  var watchPermition = false;
  var editPermition = false;

  var deletePermition = false;
  var note = false;
  FilePermisions(
      {required this.filePermision,
      required this.codePermesion,
      required this.watchPermition,
      required this.editPermition,
      required this.deletePermition,
      required this.note});
}
