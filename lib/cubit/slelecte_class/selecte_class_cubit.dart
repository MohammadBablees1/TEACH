import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'selecte_class_state.dart';

class SelecteClassCubit extends Cubit<SelecteClassState> {
  SelecteClassCubit() : super(SelecteClassInitial());

  selecteClass(selectedClass) {
    emit(SelecteClass(selectedClass: selectedClass));
  }
}
