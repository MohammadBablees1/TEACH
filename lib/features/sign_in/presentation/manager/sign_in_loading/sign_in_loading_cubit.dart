import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:teach/features/sign_in/repo/sign_in_repo.dart';

part 'sign_in_loading_state.dart';

class SignInLoadingCubit extends Cubit<SignInLoadingState> {
  SignInLoadingCubit() : super(SignInLoadingInitial());

  loading( email, password, universityNumber, context) async {
    emit(SignInLoading(loading: true));

    await SignInRepo().signIn(email, password, universityNumber, context);
  }

  managerLoading( email, password, universityNumber, context, code)async{
     emit(SignInLoading(loading: true));
     await SignInRepo().managerSignIn(
                                  context,
                                  email, password, code, universityNumber);
  }

  stop() {
    emit(SignInLoading(loading: false));
  }
}
