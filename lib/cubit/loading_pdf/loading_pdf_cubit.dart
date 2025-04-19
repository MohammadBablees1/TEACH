import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'loading_pdf_state.dart';

class LoadingPdfCubit extends Cubit<LoadingPdfState> {
  LoadingPdfCubit() : super(LoadingPdfInitial());

  loadingPdf(loading) {
    emit(LoadingPdf(loading: loading));
  }
}
