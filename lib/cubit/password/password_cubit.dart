import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:meta/meta.dart';
import 'package:teach/main.dart';
import 'package:uuid/uuid.dart';

part 'password_state.dart';

class PasswordCubit extends Cubit<PasswordState> {
  PasswordCubit() : super(PasswordInitial());

  changePasswordVisibility(isVisible) {
    emit(VisiblePassword(isVisible: isVisible));
  }

  changePermision(file, code) {
    emit(
      FilePermisions(filePermision: file, codePermesion: code),
    );
  }

  Future<void> createManagerAccount({
    required String name,
    required String phone,
    required String email,
    required String password,
    required bool filePermision,
    required bool codePermision,
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
        'code': code,
        "email": email,
      });
    } catch (e) {
      print('Error creating manager account: $e');
      rethrow;
    }
  }

  createCodes({required name, required number}) async {
    var codes = [];

    for (var i = 0; i < number; i++) {
      var code = Uuid().v4();
      codes.add(code);
    }
    for (var i = 0; i < number; i++) {
      await supabase.from("codes").insert({"id": codes[i], "name": name});
    }
  }
}
