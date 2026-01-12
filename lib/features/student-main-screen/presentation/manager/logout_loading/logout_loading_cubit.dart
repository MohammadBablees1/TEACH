import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'logout_loading_state.dart';

class LogoutLoadingCubit extends Cubit<LogoutLoadingState> {
  LogoutLoadingCubit() : super(LogoutLoadingInitial());

  start() {
    emit(LogoutLoading(loading: true));
  }

  stope() {
    emit(LogoutLoading(loading: false));
  }
}
