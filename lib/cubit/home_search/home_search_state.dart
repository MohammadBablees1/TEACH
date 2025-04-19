part of 'home_search_cubit.dart';

@immutable
sealed class HomeSearchState {}

final class HomeSearchInitial extends HomeSearchState {}

class SendSearchValue extends HomeSearchState {
  var search = false, searchValue = "";
  SendSearchValue({required this.search, required this.searchValue});
}
