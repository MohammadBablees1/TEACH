part of 'catch_code_for_sign_in_cubit.dart';

@immutable
sealed class CatchCodeForSignInState {}

final class CatchCodeForSignInInitial extends CatchCodeForSignInState {}

final class CatchCodeForSignIn extends CatchCodeForSignInState {
  final String code;
  CatchCodeForSignIn({required this.code});
}
