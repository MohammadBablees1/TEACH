import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/main.dart';

class UpdatePasswordRepo {
  update(context, widget) async {
    try {
      var box = Hive.box(hiveBoxName);
      if (box.get(isMainManager)) {
        var data = await supabase.from("main_manager").select();

        if (data[0]["password"] ==
            widget.currentPasswordController.text.trim()) {
          await supabase.auth.updateUser(
            UserAttributes(password: widget.newPasswordController.text.trim()),
          );
          await supabase.from("main_manager").update({
            "password": widget.newPasswordController.text.trim()
          }).eq("password", widget.currentPasswordController.text.trim());
        } else {
          lunchAwesomDialoge(
              DialogType.error,
              "e",
              getDeviceLocale() == "ar"
                  ? "كلمة السر خاطئة"
                  : "Incorrect password",
              // ignore: use_build_context_synchronously
              context,
              // ignore: use_build_context_synchronously
              getWidth(context),
              // ignore: use_build_context_synchronously
              getHeight(context));
        }
      } else {
        try {
          var data = await supabase
              .from("current_user")
              .select()
              .eq("id", supabase.auth.currentUser!.id);

          if (data[0]["password"] ==
              widget.currentPasswordController.text.trim()) {
            await supabase.auth.updateUser(
              UserAttributes(
                  password: widget.newPasswordController.text.trim()),
            );
            await supabase.from("current_user").update({
              "password": widget.newPasswordController.text.trim()
            }).eq("id", data[0]["id"]);
          } else {
            lunchAwesomDialoge(
                DialogType.error,
                "e",
                getDeviceLocale() == "ar"
                    ? "كلمة السر خاطئة"
                    : "Incorrect password",
                // ignore: use_build_context_synchronously
                context,
                // ignore: use_build_context_synchronously
                getWidth(context),
                // ignore: use_build_context_synchronously
                getHeight(context));
          }
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }

          lunchAwesomDialoge(
              DialogType.error,
              "e",
              e.toString(),
              // ignore: use_build_context_synchronously
              context,
              // ignore: use_build_context_synchronously
              getWidth(context),
              // ignore: use_build_context_synchronously
              getHeight(context));
        }
      }

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      lunchAwesomDialoge(
          DialogType.error,
          "e",
          getDeviceLocale() == "ar" ? "يوجد خطأ ما" : "There is an error",
          // ignore: use_build_context_synchronously
          context,
          // ignore: use_build_context_synchronously
          getWidth(context),
          // ignore: use_build_context_synchronously
          getHeight(context));
    }
  }
}
