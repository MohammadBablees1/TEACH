import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'lunch_loading_state.dart';

class LunchLoadingCubit extends Cubit<LunchLoadingState> {
  LunchLoadingCubit() : super(LunchLoadingInitial());

  lunchLoading(loading) {
    emit(LunchLoading(loading: loading));
  }

  lunchEditLoading(loading) {
    emit(EditLoading(loading: loading));
  }
}
