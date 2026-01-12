// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'manager_screen_state.dart';

class ManagerScreenCubit extends Cubit<ManagerScreenState> {
  ManagerScreenCubit() : super(ManagerScreenInitial());

  changeIndex(currentIndex) {
    emit(Indexed(currentIndex: currentIndex));
  }
}
