import 'package:hive/hive.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/main.dart';

class InitUserInfo {

  init(widget)async{
       var hiveInfo = [];
    var info = supabase.auth.currentUser;
    var box = Hive.box(hiveBoxName);

    var checkInternet = await checkConnection();

    if (box.get("info") == null && checkInternet || box.get("info").isEmpty) {
      var data = await supabase
          .from("current_user")
          .select()
          .eq("email", info!.email.toString())
          .maybeSingle();

      var checkManagerInstance = await supabase
          .from("manager")
          .select()
          .eq("email", info.email.toString())
          .maybeSingle();
      var checkMainManagerInstance = await supabase
          .from("main_manager")
          .select()
          .eq("email", info.email.toString())
          .maybeSingle();

      //  print(info.email.toString());

      if (data != null) {
        widget.nameController.text = data["name"];
        hiveInfo.add(widget.nameController.text);
        widget.phoneController.text = data["phone_number"].toString();
        hiveInfo.add(widget.phoneController.text);
        widget.emailController.text = info.email!;
        widget.universityNumberController.text =
            data["university_number"].toString();
        hiveInfo.add(widget.emailController.text);
        hiveInfo.add(widget.universityNumberController.text);
        widget.typeController.text =
            getDeviceLocale() == "ar" ? "حساب طالب" : "Student account";
        hiveInfo.add(widget.typeController.text);
        widget.currentUser = info.id;
      } else if (checkManagerInstance != null) {
        widget.nameController.text = checkManagerInstance["name"];
        hiveInfo.add(widget.nameController.text);
        widget.phoneController.text = checkManagerInstance["phone"].toString();
        hiveInfo.add(widget.phoneController.text);
        widget.emailController.text = info.email!;
        hiveInfo.add(widget.emailController.text);
        widget.typeController.text =
            getDeviceLocale() == "ar" ? "حساب مدير" : "Manager account";
        hiveInfo.add(widget.typeController.text);
      } else if (checkMainManagerInstance != null) {
        widget.nameController.text = checkMainManagerInstance["name"];
        hiveInfo.add(widget.nameController.text);
        widget.phoneController.text =
            checkMainManagerInstance["phone"].toString();
        hiveInfo.add(widget.phoneController.text);
        widget.emailController.text = info.email!;
        hiveInfo.add(widget.emailController.text);
        widget.typeController.text = getDeviceLocale() == "ar"
            ? "حساب مالك التطبيق"
            : "App Owner Account";
        hiveInfo.add(widget.typeController.text);
      }
      box.put("info", hiveInfo);
    } else if (box.get("info") != null) {
      widget.nameController.text = box.get("info")[0].toString();
      widget.phoneController.text = box.get("info")[1].toString();
      widget.emailController.text = box.get("info")[2].toString();
      if (box.get(isStudent)) {
        widget.universityNumberController.text = box.get("info")[3].toString();
        widget.typeController.text = box.get("info")[4].toString();
      }
    }
  }

}