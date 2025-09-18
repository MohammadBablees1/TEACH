import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'lunch_loading_state.dart';

class LunchLoadingCubit extends Cubit<LunchLoadingState> {
  LunchLoadingCubit() : super(LunchLoadingInitial());

  lunchLoading(loading) {
    emit(LunchLoading(loading: loading));
  }

  lunchEditLoading(loading) {
    emit(EditLoading(loading: loading));
  }

  uploadCode(isLoading) {
    emit(UploadCodeLoading(loading: isLoading));
  }

  getCodeLoding(loading, index) {
    emit(GetCodeLoading(loading: loading, index: index));
    
  }

  generatePdf(loading, index) {
    emit(GeneratePdf(loading: loading, index: index));
    
  }
  deleteAllCodesFromUser(loading, index) {
    emit(DeleteAllCodesFromUser(loading: loading, index: index));
  }
  sendNotification(loading) {
    emit(SendNotification(loading: loading));
    
  }
}
