import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:teach/features/student-main-screen/repo/buy_code_repo.dart';

part 'manual_code_loading_state.dart';

class ManualCodeLoadingCubit extends Cubit<ManualCodeLoadingState> {
  ManualCodeLoadingCubit() : super(ManualCodeLoadingInitial());

  startLoading() {
    emit(ManualCodeLoading(loading: true));
  }

  buyCode(context, code) async {
    BuyCodeRepo buyCodeRepo = BuyCodeRepo();
    buyCodeRepo.buyCode(context, code);
  }

  stope() {
    emit(ManualCodeLoading(loading: false));
  }
}
