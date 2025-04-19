import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'timer_cubit_state.dart';

class TimerCubitCubit extends Cubit<TimerCubitState> {
  TimerCubitCubit() : super(TimerCubitInitial());

  changeTime(timer) async {
    emit(ChangeTime(timer: timer));
  }
}
