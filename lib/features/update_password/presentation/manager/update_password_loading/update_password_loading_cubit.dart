import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'update_password_loading_state.dart';

class UpdatePasswordLoadingCubit extends Cubit<UpdatePasswordLoadingState> {
  UpdatePasswordLoadingCubit() : super(UpdatePasswordLoadingInitial());

  start() {
    emit(UpdatePasswordLoading(loading: true));
  }

  stope() {
    emit(UpdatePasswordLoading(loading: false));
  }
}
