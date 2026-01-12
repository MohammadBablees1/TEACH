// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:teach/data/repository/folder_repo.dart';
import 'package:teach/main.dart';

part 'add_folder_loading_state.dart';

class AddFolderLoadingCubit extends Cubit<AddFolderLoadingState> {
  AddFolderLoadingCubit() : super(AddFolderLoadingInitial());

  addFolderLoading(loading) {
    emit(AddFolderLoading(loading: loading));
  }

  crateFolder(selectedImage, nameController, context) async {
    FolderRepository repo = FolderRepository(supabase);
    await repo.createFolder(
        selectedImage: selectedImage,
        
        nameController.text.trim(),
      
        context);
  }
}
