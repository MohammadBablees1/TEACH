part of 'selected_code_search_cubit.dart';

@immutable
sealed class SelectedCodeSearchState {}

final class SelectedCodeSearchInitial extends SelectedCodeSearchState {}

final class SearchedCode extends SelectedCodeSearchState {
  var search = "";
  SearchedCode({required this.search});
}
