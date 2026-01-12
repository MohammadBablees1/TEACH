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

final class UploadCodeLoading extends LunchLoadingState {
  var loading = false;
  UploadCodeLoading({required this.loading});
}

final class GetCodeLoading extends LunchLoadingState {
  var loading = false, index = 0;
  
  GetCodeLoading({required this.loading, required this.index});
}

final class GeneratePdf extends LunchLoadingState {
  var loading = false, index = 0;
  GeneratePdf({required this.loading, required this.index});
}

final class DeleteAllCodesFromUser extends LunchLoadingState {
  var loading = false, index = 0;
  DeleteAllCodesFromUser({required this.loading, required this.index});
}

final class SendNotification extends LunchLoadingState {
  var loading = false;
  SendNotification({required this.loading});
}
