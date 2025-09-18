import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'selected_code_search_state.dart';

class SelectedCodeSearchCubit extends Cubit<SelectedCodeSearchState> {
  SelectedCodeSearchCubit() : super(SelectedCodeSearchInitial());

  searchForCode(search) {
    emit(SearchedCode(search: search));
  }
}
