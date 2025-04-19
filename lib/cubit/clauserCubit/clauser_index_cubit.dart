import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'clauser_index_state.dart';

class ClauserIndexCubit extends Cubit<ClauserIndexState> {
  ClauserIndexCubit() : super(ClauserIndexInitial());




    void changeIndex(newIndex){
    emit(ChangeIndex(newIndex: newIndex));
  }
}
