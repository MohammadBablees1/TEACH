import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'manager_screen_state.dart';

class ManagerScreenCubit extends Cubit<ManagerScreenState> {
  ManagerScreenCubit() : super(ManagerScreenInitial());

  changeIndex(currentIndex) {
    emit(Indexed(currentIndex: currentIndex));
  }
}
