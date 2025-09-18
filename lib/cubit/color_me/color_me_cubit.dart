import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'color_me_state.dart';

class ColorMeCubit extends Cubit<ColorMeState> {
  ColorMeCubit() : super(ColorMeInitial());

  selectMe(selectMe) {
    emit(SelectMe(selected: selectMe));
  }

  resetMe() {
    emit(ResetMe());
  }
}
