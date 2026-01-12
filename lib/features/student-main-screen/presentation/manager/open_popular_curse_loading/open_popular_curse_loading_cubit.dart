import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'open_popular_curse_loading_state.dart';

class OpenPopularCurseLoadingCubit extends Cubit<OpenPopularCurseLoadingState> {
  OpenPopularCurseLoadingCubit() : super(OpenPopularCurseLoadingInitial());

  start() {
    emit(OpenPopularCurseLoading(loading: true));
  }

  stope() {
    emit(OpenPopularCurseLoading(loading: false));
  }
}
