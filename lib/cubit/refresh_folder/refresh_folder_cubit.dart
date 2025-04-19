import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'refresh_folder_state.dart';

class RefreshFolderCubit extends Cubit<RefreshFolderState> {
  RefreshFolderCubit() : super(RefreshFolderInitial());

  refreshPage() {
    emit(Refresh());
  }
}
