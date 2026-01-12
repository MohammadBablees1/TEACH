import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'current_password_visibility_state.dart';

class CurrentPasswordVisibilityCubit
    extends Cubit<CurrentPasswordVisibilityState> {
  CurrentPasswordVisibilityCubit() : super(CurrentPasswordVisibilityInitial());

  visible() {
    emit(CurrentPasswordVisibility(isVisible: false));
  }

  inVisible() {
    emit(CurrentPasswordVisibility(isVisible: true));
  }
}
