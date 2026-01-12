import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/features/main-screen/presentation/view/main_screen.dart';
import 'package:teach/features/sign_in/data/data_from_supa_for_sign_in.dart';
import 'package:teach/features/sign_in/data/update_data_for_sign_in.dart';
import 'package:teach/main.dart';
import 'package:teach/features/student-main-screen/presentation/student_main_screen.dart';

class SignInRepo {
  signIn(userEmail, userPassword, universityNumber, context) async {
    var user = await supabase.auth.signInWithPassword(
      email: userEmail,
      password: userPassword,
    );
    var email = user.user!.email;
    var mainManager = await DataFromSupaForSignIn().getMAinManager();
    if (userEmail == mainManager!["email"] && universityNumber == "0000") {
      var box = Hive.box(hiveBoxName);

      box.put(isMainManager, true);
      var mainManager = await supabase.from("main_manager").select();
      box.put("Mname", mainManager[0]["name"]);
    }
    var box = Hive.box(hiveBoxName);
    if (box.get(isMainManager) == null) {
      final mobileDeviceIdentifier =
          await MobileDeviceIdentifier().getDeviceId();
      var userData = await DataFromSupaForSignIn()
          .getUSerByUniversityNumber(universityNumber, user);

      if (userData != null) {
        var deviceId = await userData["deviceId"];

        if (deviceId == mobileDeviceIdentifier || deviceId.isEmpty) {
          box.put(isStudent, true);
          box.put(isMainManager, false);
          box.put(isManager, false);
          if (deviceId == "") {
            await UpdateDataForSignIn()
                .updateDeviceId(mobileDeviceIdentifier, email);
          }

          box.put("student_name", userData["name"]);
          
        
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => StudentMainScreen(),
              ),
              (Route<dynamic> route) => false);
        } else {
          await supabase.auth.signOut();
          lunchAwesomDialoge(
              DialogType.error,
              "e",
              getDeviceLocale() == "ar"
                  ? "لا يمكن تسجيل الدخول المتعدد لنفس الحساب"
                  : "Multiple logins to the same account are not possible.",
              context,
              getWidth(context),
              getHeight(context));
         
        }
      } else {
        
        await supabase.auth.signOut();
        lunchAwesomDialoge(
            DialogType.error,
            "e",
            getDeviceLocale() == "ar"
                ? "الحساب غير متوفر"
                : "Account unavailable",
            context,
            getWidth(context),
            getHeight(context));
      }
    } else if (box.get(isMainManager)) {
     
      box.put(isStudent, false);
      box.put(isManager, false);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MainScreen(),
          ),
          (Route<dynamic> route) => false);
    }
  }

  managerSignIn(
      context, String userEmail, password, code, universityNumber) async {
    try {
      var user = await supabase.auth.signInWithPassword(
        email: userEmail,
        password: password,
      );

      var email = user.user?.email;
      var data = await supabase
          .from("manager")
          .select()
          .eq("email", email.toString())
          .eq("code", code)
          .maybeSingle();

      if (data != null && universityNumber == "1111") {
        // ignore: use_build_context_synchronously
       
        var box = Hive.box(hiveBoxName);
        box.put(isManager, true);
        box.put(isMainManager, false);
        box.put(isStudent, false);
        box.put(isCode, data["codeP"]);
        box.put(isFile, data["file"]);
        box.put(watching, data["watch"]);
        box.put(editing, data["edite"]);
        box.put(noting, data["not"]);
        box.put(deleting, data["delete"]);
        await initUserInfo();
      
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ),
            (Route<dynamic> route) => false);
      } else {
        // ignore: use_build_context_synchronously
   
        await supabase.auth.signOut();
        lunchAwesomDialoge(
            DialogType.error,
            "e",
            getDeviceLocale() == "ar"
                ? "الكود غير صالح"
                : "The code is invalid",
            // ignore: use_build_context_synchronously
            context,
            getWidth(context),
            getHeight(context));
      }
      // Handle successful login here
    } catch (error) {
      // ignore: use_build_context_synchronously
   

      if (error.toString().contains(
          "The password is invalid")) {
        lunchAwesomDialoge(
            DialogType.error,
            "e",
            getDeviceLocale() == "ar" ? "كلمة السر خاطئة!" : "Wrong password!",
            context,
            getWidth(context),
            getHeight(context));
      } else if (error.toString().contains("email")) {
        lunchAwesomDialoge(
            DialogType.error,
            "e",
            getDeviceLocale() == "ar"
                ? "توجد مشكلة في البريد الإلكتروني!"
                : "Wrong email!",
            context,
            getWidth(context),
            getHeight(context));
      } else {
        lunchAwesomDialoge(
            DialogType.error,
            "e",
            getDeviceLocale() == "ar"
                ? "يوجد خطأ ما!"
                : "Something went wrong!",
            context,
            getWidth(context),
            getHeight(context));
      }
    }
  }
}
