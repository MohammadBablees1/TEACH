import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_search_state.dart';

class HomeSearchCubit extends Cubit<HomeSearchState> {
  HomeSearchCubit() : super(HomeSearchInitial());

  searchForValue(search, String searchValue) {
    
    emit(SendSearchValue(search: search, searchValue: searchValue));
    
  }
}
