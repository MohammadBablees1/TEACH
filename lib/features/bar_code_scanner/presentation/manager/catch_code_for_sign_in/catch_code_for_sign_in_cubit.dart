import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'catch_code_for_sign_in_state.dart';

class CatchCodeForSignInCubit extends Cubit<CatchCodeForSignInState> {
  CatchCodeForSignInCubit() : super(CatchCodeForSignInInitial());

  catchCodeForSignIn(code) {
    emit(CatchCodeForSignIn(code: code));
  }
}
