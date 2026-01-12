import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'login_confirm_password_visibility_state.dart';

class LoginConfirmPasswordVisibilityCubit
    extends Cubit<LoginConfirmPasswordVisibilityState> {
  LoginConfirmPasswordVisibilityCubit()
      : super(LoginConfirmPasswordVisibilityInitial());

  changeVisibility(isVisible) {
    emit(LoginConfirmPasswordVisibility(isVisible: isVisible));
  }
}
