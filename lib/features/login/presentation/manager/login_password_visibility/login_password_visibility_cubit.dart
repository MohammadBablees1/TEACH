import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'login_password_visibility_state.dart';

class LoginPasswordVisibilityCubit extends Cubit<LoginPasswordVisibilityState> {
  LoginPasswordVisibilityCubit() : super(LoginPasswordVisibilityInitial());

  changeVisibility(isVisible) {
    emit(LoginPasswordVisibility(isVisible: isVisible));
  }
}
