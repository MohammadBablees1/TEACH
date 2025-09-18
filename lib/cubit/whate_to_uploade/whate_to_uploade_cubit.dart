import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'whate_to_uploade_state.dart';

class WhateToUploadeCubit extends Cubit<WhateToUploadeState> {
  WhateToUploadeCubit() : super(WhateToUploadeInitial());

  select(all, video, pdf, questionBank, folder, teacher) {
    emit(SelectToUploade(
        all: all, video: video, pdf: pdf, questionBank: questionBank, folder: folder, teacher: teacher));
  }
}
