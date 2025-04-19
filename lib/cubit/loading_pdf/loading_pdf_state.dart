part of 'loading_pdf_cubit.dart';

@immutable
sealed class LoadingPdfState {}

final class LoadingPdfInitial extends LoadingPdfState {}

class LoadingPdf extends LoadingPdfState {
  var loading = false;
  LoadingPdf({required this.loading});
}
