import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/features/student-main-screen/presentation/manager/manual_code_loading/manual_code_loading_cubit.dart';
import 'package:teach/main.dart';

class BuyCodeRepo {
  buyCode(context, code) async {
    try {
      var check = false;
      var codes = await supabase.from("codes").select();
      for (var i = 0; i < codes.length; i++) {
        if (codes[i]["id"] == code) {
          var user = await supabase
              .from("current_user")
              .select()
              .eq("id", supabase.auth.currentUser!.id);
          var code = user[0]["codes"];

          if (code.toString().contains(codes[i]["folder_id"])) {
            // ignore: use_build_context_synchronously
            context.read<ManualCodeLoadingCubit>().stope();
            lunchAwesomDialoge(
                DialogType.error,
                "e",
                getDeviceLocale() == "ar"
                    ? "لقد اشتركت بالفعل بهذا الكورس"
                    : "You have already signed up for this course.",
                // ignore: use_build_context_synchronously
                context,
                // ignore: use_build_context_synchronously
                getWidth(context),
                // ignore: use_build_context_synchronously
                getHeight(context));
            check = true;
            break;
          }
          code.add(codes[i]["folder_id"]);
          await supabase
              .from("current_user")
              .update({"codes": code}).eq("id", supabase.auth.currentUser!.id);
          await supabase.from("codes").delete().eq("id", codes[i]["id"]);
          var ch = await supabase
              .from("sold_codes")
              .select()
              .eq("name", codes[i]["name"])
              .maybeSingle();
          if (ch != null) {
            var total = int.parse(ch["count"].toString());
            total++;
            await supabase
                .from("sold_codes")
                .update({"count": total}).eq("id", ch["id"]);
          } else {
            await supabase
                .from("sold_codes")
                .insert({"name": codes[i]["name"], "count": 1});
          }

          check = true;
          // ignore: use_build_context_synchronously
          context.read<ManualCodeLoadingCubit>().stope();
          Fluttertoast.showToast(
              msg: getDeviceLocale() == "ar"
                  ? "تمّ شراء الكورس بنجاح"
                  : "The course has been successfully purchased.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          break;
        }
      }
      if (!check) {
        // ignore: use_build_context_synchronously
        context.read<ManualCodeLoadingCubit>().stope();
        lunchAwesomDialoge(
            DialogType.error,
            "e",
            getDeviceLocale() == "ar"
                ? "الكود غير صالح"
                : "The code is invalid",
            // ignore: use_build_context_synchronously
            context,
            // ignore: use_build_context_synchronously
            getWidth(context),
            // ignore: use_build_context_synchronously
            getHeight(context));
      }
    } catch (e) {
      lunchAwesomDialoge(DialogType.error, "e", e.toString(), context,
          getWidth(context), getHeight(context));
    }
  }
}
