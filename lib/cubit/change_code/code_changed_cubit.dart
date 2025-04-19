import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'code_changed_state.dart';

class CodeChangedCubit extends Cubit<CodeChangedState> {
  CodeChangedCubit() : super(CodeChangedInitial());

  changeCode(code) {
    emit(ChangeCode(code: code));
  }
}
