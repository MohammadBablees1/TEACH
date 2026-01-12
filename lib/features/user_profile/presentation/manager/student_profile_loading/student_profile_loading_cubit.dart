import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'student_profile_loading_state.dart';

class StudentProfileLoadingCubit extends Cubit<StudentProfileLoadingState> {
  StudentProfileLoadingCubit() : super(StudentProfileLoadingInitial());

  start() {
    emit(StudentProfileLoading(loadng: true));
  }

    stope() {
    emit(StudentProfileLoading(loadng: false));
  }

}
