// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:teach/main.dart';

part 'add_phone_number_state.dart';

class AddPhoneNumberCubit extends Cubit<AddPhoneNumberState> {
  AddPhoneNumberCubit() : super(AddPhoneNumberInitial());

  addPhoneNumberLoading(loading) {
    emit(AddPhoneNumberLoading(loading: loading));
  }

  Future addSellPoint(nameController, phoneController) async {
    await supabase.from("sell_point").insert({
      "name": nameController.text.trim(),
      "phone": phoneController.text.trim()
    });
  }
}
