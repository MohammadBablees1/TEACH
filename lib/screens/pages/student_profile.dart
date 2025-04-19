import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teach/cubit/lunch_loading_cubit/lunch_loading_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/main.dart';

class StudentProfile extends StatefulWidget {
  late TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  var currentUser = "";
  var home = true, len = 0;
  var currentIndex = 0;
  var name = "", loading = false;
  var isEditing = false;
  var emailEditing = false;
  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  GlobalKey<FormState> globalKey = GlobalKey();
  @override
  initState() {
    super.initState();
    initUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                  width: getWidth(context) * .2,
                  height: getWidth(context) * .2,
                  child: CircleAvatar(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          "images/icon.jpg",
                          width: getWidth(context),
                          fit: BoxFit.cover,
                        )),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: AlignmentDirectional.topStart,
                  child: Center(
                    child: Text(
                      getDeviceLocale() == "ar"
                          ? "معلومات الحساب"
                          : "Account Information",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Form(
              key: globalKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value) {
                        return nameValidator(value!);
                      },
                      cursorColor: mode ? Colors.white : dayBar["blue"],
                      readOnly: checkManager(),
                      controller: widget.nameController,
                      onChanged: (value) {
                        widget.nameController.text = value;
                        widget.isEditing = true;
                      },
                      style: TextStyle(
                          color: mode
                              ? Colors.white
                              : const Color.fromARGB(255, 11, 85, 145)),
                      decoration: InputDecoration(
                        prefix: Text(
                          getDeviceLocale() == "ar"
                              ? "اسم المستخدم : "
                              : "User name : ",
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                width: 1,
                                color: mode
                                    ? nightBar["orange"]
                                    : const Color.fromARGB(255, 11, 85, 145))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                width: 1.5,
                                color: mode
                                    ? nightBar["orange"]
                                    : const Color.fromARGB(255, 11, 85, 145))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value) {
                        return phoneValidator(value!);
                      },
                      cursorColor: mode ? Colors.white : dayBar["blue"],
                      readOnly: checkManager(),
                      controller: widget.phoneController,
                      onChanged: (value) {
                        widget.phoneController.text = value;
                        widget.isEditing = true;
                      },
                      style: TextStyle(
                          color: mode
                              ? Colors.white
                              : const Color.fromARGB(255, 11, 85, 145)),
                      decoration: InputDecoration(
                        prefix: Text(getDeviceLocale() == "ar"
                            ? " رقم الهاتف : "
                            : " Phone number : "),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                width: 1,
                                color: mode
                                    ? nightBar["orange"]
                                    : const Color.fromARGB(255, 11, 85, 145))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                width: 1,
                                color: mode
                                    ? nightBar["orange"]
                                    : const Color.fromARGB(255, 11, 85, 145))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                width: 1.5,
                                color: mode
                                    ? nightBar["orange"]
                                    : const Color.fromARGB(255, 11, 85, 145))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: widget.emailController,
                      onChanged: (email) {
                        widget.emailEditing = true;
                        widget.emailController.text = email;
                      },
                      style: TextStyle(
                          color: mode
                              ? Colors.white
                              : const Color.fromARGB(255, 11, 85, 145)),
                      decoration: InputDecoration(
                        prefix: Text(getDeviceLocale() == "ar"
                            ? "البريد الإلكتروني: "
                            : "Email : "),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                width: 1,
                                color: mode
                                    ? nightBar["orange"]
                                    : const Color.fromARGB(255, 11, 85, 145))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                width: 1.5,
                                color: mode
                                    ? nightBar["orange"]
                                    : const Color.fromARGB(255, 11, 85, 145))),
                      ),
                    ),
                  ),
                  BlocBuilder<LunchLoadingCubit, LunchLoadingState>(
                    builder: (context, state) {
                      var box = Hive.box(hiveBoxName);

                      return ElevatedButton(
                        onPressed: () async {
                          if (await checkConnection()) {
                            if (widget.isEditing &&
                                globalKey.currentState!.validate()) {
                              context
                                  .read<LunchLoadingCubit>()
                                  .lunchEditLoading(true);
                              try {
                                var currentUser = supabase.auth.currentUser;

                                var box = Hive.box(hiveBoxName);

                                await supabase.from("current_user").update({
                                  "name": widget.nameController.text,
                                  "phone_number": widget.phoneController.text,
                                  "email": widget.emailController.text,
                                }).eq(
                                    "id", await supabase.auth.currentUser!.id);

                                if (widget.emailEditing) {
                                  await supabase.auth.updateUser(
                                    UserAttributes(
                                      email: widget.emailController.text,
                                    ),
                                  );
                                }
                                var info = box.get("info");
                                info[0] = widget.nameController.text;
                                info[1] = widget.phoneController.text;
                                info[2] = widget.emailController.text;
                                box.put("info", info);

                                context
                                    .read<LunchLoadingCubit>()
                                    .lunchEditLoading(false);
                                lunchAwesomDialoge(
                                    DialogType.success,
                                    "e",
                                    getDeviceLocale() == "ar"
                                        ? "تمّ التعديل بنجاح"
                                        : "Modified successfully",
                                    context,
                                    getWidth(context),
                                    getHeight(context));
                              } catch (e) {
                                context
                                    .read<LunchLoadingCubit>()
                                    .lunchEditLoading(false);
                                lunchAwesomDialoge(
                                    DialogType.warning,
                                    "e",
                                    getDeviceLocale() == "ar"
                                        ? "يوجد خطأ ما!"
                                        : "Something is wrong!",
                                    context,
                                    getWidth(context),
                                    getHeight(context));
                              }
                              // await currentUser
                              //     .verifyBeforeUpdateEmail(widget.emailController.text);
                            } else {
                              lunchAwesomDialoge(
                                  DialogType.warning,
                                  "e",
                                  getDeviceLocale() == "ar"
                                      ? "لا يوجد تعديلات ليتم تعديلها"
                                      : "There are no modifications to be made.",
                                  context,
                                  getWidth(context),
                                  getHeight(context));
                            }
                          } else {
                            lunchAwesomDialoge(
                                DialogType.warning,
                                "e",
                                getDeviceLocale() == "ar"
                                    ? "تأكد من اتصالك بالإنترنت"
                                    : "Make sure you are connected to the Internet",
                                context,
                                getWidth(context),
                                getHeight(context));
                          }
                        },
                        child: state is EditLoading
                            ? state.loading
                                ? Container(
                                    width: 50,
                                    height: 50,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    getDeviceLocale() == "ar"
                                        ? "تعديل"
                                        : "Edite Account",
                                    style: TextStyle(color: Colors.white),
                                  )
                            : Text(
                                getDeviceLocale() == "ar"
                                    ? "تعديل"
                                    : "Edite Account",
                                style: TextStyle(color: Colors.white),
                              ),
                        style: ElevatedButton.styleFrom(
                            side: BorderSide(
                          width: .5,
                        )),
                      );
                    },
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Future initUserInfo() async {
    var hiveInfo = [];
    var info = supabase.auth.currentUser;
    var box = Hive.box(hiveBoxName);

    var checkInternet = await checkConnection();

    if (box.get("info") == null && checkInternet) {
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
      print("+++++++++++++++");
      print(data == null);
      print(checkManagerInstance == null);
      print(checkMainManagerInstance == null);
      //  print(info.email.toString());
      if (data != null) {
        widget.nameController.text = data["name"];
        hiveInfo.add(widget.nameController.text);
        widget.phoneController.text = data["phone_number"].toString();
        hiveInfo.add(widget.phoneController.text);
        widget.emailController.text = info.email!;
        hiveInfo.add(widget.emailController.text);
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
      widget.nameController.text = box.get("info")[0];
      widget.phoneController.text = box.get("info")[1];
      widget.emailController.text = box.get("info")[2];
      widget.typeController.text = box.get("info")[3];
    }
  }
}
