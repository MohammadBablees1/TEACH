import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/main.dart';
import 'package:uuid/uuid.dart';
part 'password_state.dart';

class PasswordCubit extends Cubit<PasswordState> {
  PasswordCubit() : super(PasswordInitial());

  changePasswordVisibility(isVisible) {
    emit(VisiblePassword(isVisible: isVisible));
  }

  changePermision(file, code, watch, edite, delete, not) {
    emit(
      FilePermisions(
          filePermision: file,
          codePermesion: code,
          watchPermition: watch,
          editPermition: edite,
          deletePermition: delete,
          note: not),
    );
  }

  Future<void> createManagerAccount({
    required String name,
    required String phone,
    required String email,
    required String password,
    required bool filePermision,
    required bool codePermision,
    required bool watchPermition,
    required bool editePermition,
    required bool deletePermition,
  }) async {
    try {
      // 1. Create the user in Supabase Auth
      final authResponse = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'phone': phone,
        },
      );

      final code = Uuid().v4(); // Generate UUID

      // 2. Store additional manager data in the 'manager' table
      await supabase.from('manager').insert({
        'name': name,
        'phone': phone,
        'file': filePermision,
        'codeP': codePermision,
        "watch": watchPermition,
        "edite": editePermition,
        "delete": deletePermition,
        'code': code,
        "email": email,
        "password": password,
        "university_number": "1111"
      });
     
    } catch (e) {
      if (kDebugMode) {
        print('Error creating manager account: $e');
      }
      rethrow;
    }
  }

  createCodes({required name, required number}) async {
    var codes = [];

    for (var i = 0; i < number; i++) {
      var code = Uuid().v4();
      codes.add(code);
    }

    var data = await supabase
        .from("folders")
        .select()
        .eq("name", name.toString().split("-").last.toString());
    var id = 0;
    for (var i = 0; i < data.length; i++) {
      id = data[i]["id"];

      while (data[i]["parent_id"] != null) {
        data = await supabase
            .from("folders")
            .select()
            .eq("id", data[i]["parent_id"]);
      }
      String root = name.toString().split("-").first.toString();

      if (root.contains(data[i]["name"])) {
        break;
      }
    }
    for (var i = 0; i < number; i++) {
      await supabase
          .from("codes")
          .insert({"id": codes[i], "name": name, "folder_id": id});
    }
  }
}
