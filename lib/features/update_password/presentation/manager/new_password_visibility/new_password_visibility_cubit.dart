import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'new_password_visibility_state.dart';

class NewPasswordVisibilityCubit extends Cubit<NewPasswordVisibilityState> {
  NewPasswordVisibilityCubit() : super(NewPasswordVisibilityInitial());

   visible() {
    emit(NewPasswordVisibility(isVisible: false));
  }

  inVisible() {
    emit(NewPasswordVisibility(isVisible: true));
  }


}
