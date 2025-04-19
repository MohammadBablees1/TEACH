import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'selected_value_state.dart';

class SelectedValueCubit extends Cubit<SelectedValueState> {
  SelectedValueCubit() : super(SelectedValueInitial());

  changeValue(value) {
    emit(SelectedValue(value: value));
  }
}
