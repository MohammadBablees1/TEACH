import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'animated_container_tow_state.dart';

class AnimatedContainerTowCubit extends Cubit<AnimatedContainerTowState> {
  AnimatedContainerTowCubit() : super(AnimatedContainerTowInitial());

  chnageAnimation(manager, codes) {
    emit(ChangeAnimation(manager: manager, codes: codes));
  }
}
