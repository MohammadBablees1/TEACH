import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'change_name_state.dart';

class ChangeNameCubit extends Cubit<ChangeNameState> {
  ChangeNameCubit() : super(ChangeNameInitial());

  lunchChanging() {
    emit(ChangeName());
  }
}
