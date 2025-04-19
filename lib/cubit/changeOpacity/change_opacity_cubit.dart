import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'change_opacity_state.dart';

class ChangeOpacityCubit extends Cubit<ChangeOpacityState> {
  ChangeOpacityCubit() : super(ChangeOpacityInitial());

  changeOpacity(opacity) {
    emit(ChangeOpacity(opacity: opacity));
  }
}
