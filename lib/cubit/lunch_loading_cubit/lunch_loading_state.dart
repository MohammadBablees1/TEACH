part of 'lunch_loading_cubit.dart';

@immutable
sealed class LunchLoadingState {}

final class LunchLoadingInitial extends LunchLoadingState {}

class LunchLoading extends LunchLoadingState {
  var loading = false;
  LunchLoading({required this.loading});
}

class EditLoading extends LunchLoadingState {
  var loading = false;
  EditLoading({required this.loading});
}
