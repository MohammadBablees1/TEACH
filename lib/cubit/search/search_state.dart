part of 'search_cubit.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}

class IsSearch extends SearchState {
  var isSearch = false;
  var search = "";
  IsSearch({required this.isSearch, required this.search});
}
