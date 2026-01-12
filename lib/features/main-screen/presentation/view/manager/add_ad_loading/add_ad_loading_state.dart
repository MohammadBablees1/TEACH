part of 'add_ad_loading_cubit.dart';

@immutable
sealed class AddAdLoadingState {}

final class AddAdLoadingInitial extends AddAdLoadingState {}
// ignore: must_be_immutable
class AddAdLoading extends AddAdLoadingState {
  var loading = false;
  AddAdLoading({required this.loading});
}