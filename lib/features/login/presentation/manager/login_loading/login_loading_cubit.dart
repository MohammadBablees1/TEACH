// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'login_loading_state.dart';

class LoginLoadingCubit extends Cubit<LoginLoadingState> {
  LoginLoadingCubit() : super(LoginLoadingInitial());

  lunchLoading() {
    emit(LoginLoading(loading: true));
  }

  stope() {
    emit(LoginLoading(loading: false));
  }
}
