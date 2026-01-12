import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teach/features/user_profile/data/get_user_by_email.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/main.dart';

class EditeStudentProfileRepo {
  editeStudentProfile(context, widget) async {
    try {
      var currentUser = supabase.auth.currentUser;

      var box = Hive.box(hiveBoxName);
      PostgrestMap? checkEmail;
      if (widget.emailEditing) {
        checkEmail = await GetUserByEmail().getUser(widget);
      }

      if (checkEmail != null) {
        lunchAwesomDialoge(
            DialogType.error,
            "e",
            getDeviceLocale() == "ar"
                ? "البريد الإلكتروني مستخدم بالفعل!"
                : "Email already in use!",
            // ignore: use_build_context_synchronously
            context,
            // ignore: use_build_context_synchronously
            getWidth(context),
            // ignore: use_build_context_synchronously
            getHeight(context));
      } else {
        await supabase.from("current_user").update({
          "name": widget.nameController.text.trim(),
          "phone_number": widget.phoneController.text.trim(),
          "email": widget.emailController.text.trim(),
          "university_number": widget.universityNumberController.text.trim()
        }).eq("id", supabase.auth.currentUser!.id);
       
     
        box.put("student_name", widget.nameController.text.trim());
        // ignore: use_build_context_synchronously
        // context.read<ChangeNameCubit>().lunchChanging();
        if (widget.emailEditing) {
          await supabase.auth.updateUser(
            UserAttributes(
              email: widget.emailController.text.trim(),
            ),
          );
        }
        var info = box.get("info");
        info[0] = widget.nameController.text;
        info[1] = widget.phoneController.text;
        info[2] = widget.emailController.text;
        info[3] = widget.universityNumberController.text;
        box.put("info", info);

        lunchAwesomDialoge(
            DialogType.success,
            "e",
            getDeviceLocale() == "ar"
                ? "تمّ التعديل بنجاح"
                : "Modified successfully",
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
          DialogType.warning,
          "e",
          getDeviceLocale() == "ar" ? "يوجد خطأ ما!" : "Something is wrong!",
          // ignore: use_build_context_synchronously
          context,
          // ignore: use_build_context_synchronously
          getWidth(context),
          // ignore: use_build_context_synchronously
          getHeight(context));
    }
  }
}
