import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  changeSearch(isSearch, search) {
    emit(IsSearch(isSearch: isSearch, search: search));
  }
}
