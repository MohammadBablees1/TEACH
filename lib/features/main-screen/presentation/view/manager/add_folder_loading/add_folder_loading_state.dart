part of 'add_folder_loading_cubit.dart';

@immutable
sealed class AddFolderLoadingState {}

final class AddFolderLoadingInitial extends AddFolderLoadingState {}


// ignore: must_be_immutable
class AddFolderLoading extends AddFolderLoadingState {
  var loading = false;
  AddFolderLoading({required this.loading});
}