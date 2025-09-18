import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:teach/cubit/lunch_loading_cubit/lunch_loading_cubit.dart';
import 'package:teach/cubit/them_mode/them_mode_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/sql/sql.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/main.dart';
import 'package:teach/screens/page_veiw.dart';
import 'package:teach/screens/pages/bar_code_scanner.dart';
import 'package:teach/screens/pages/code_generater.dart';
import 'package:teach/screens/pages/record_codes.dart';
import 'package:teach/screens/pages/update_password.dart';

class Profile extends StatefulWidget {
  var home = true, len = 0;
  var currentIndex = 0;
  var name = "", loading = false;
  var isEditing = false;
  var currentUser = "";
  late TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<void> _reauthenticateAndDelete() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      // Handle exceptions
    }
  }

  GlobalKey<FormState> globalKey = GlobalKey();
  @override
  initState() {
    super.initState();
    initUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: profile_body(context),
    );
  }

  Widget profile_body(context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: AlignmentDirectional.topStart,
                child: AutoSizeText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  minFontSize: 10,
                  maxFontSize: 15,
                  getDeviceLocale() == "ar" ? "بياناتي" : "My account",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
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
                        prefix: AutoSizeText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          minFontSize: 10,
                          maxFontSize: 15,
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
                        prefix: AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            getDeviceLocale() == "ar"
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
                      readOnly: true,
                      style: TextStyle(
                          color: mode
                              ? Colors.white
                              : const Color.fromARGB(255, 11, 85, 145)),
                      decoration: InputDecoration(
                        prefix: AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            getDeviceLocale() == "ar"
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      readOnly: true,
                      controller: widget.typeController,
                      style: TextStyle(
                          color: mode
                              ? Colors.white
                              : const Color.fromARGB(255, 11, 85, 145)),
                      decoration: InputDecoration(
                        prefix: AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            getDeviceLocale() == "ar"
                                ? "نوع الحساب : "
                                : "Account type : "),
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

                      if (!checkManager()) {
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

                                  await supabase.from("main_manager").update({
                                    "name": widget.nameController.text,
                                    "phone": widget.phoneController.text
                                  }).eq("id", 1);
                                  var info = box.get("info");
                                  info[0] = widget.nameController.text;
                                  info[1] = widget.phoneController.text;
                                  box.put("info", info);

                                  context
                                      .read<LunchLoadingCubit>()
                                      .lunchEditLoading(false);
                                } catch (e) {
                                  context
                                      .read<LunchLoadingCubit>()
                                      .lunchEditLoading(false);
                                 
                                  if (kDebugMode) {
                                    print(e.toString());
                                  }
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
                                  : AutoSizeText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      minFontSize: 10,
                                      maxFontSize: 15,
                                      getDeviceLocale() == "ar"
                                          ? "تعديل"
                                          : "Edite Account",
                                      style: TextStyle(color: Colors.white),
                                    )
                              : AutoSizeText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  minFontSize: 10,
                                  maxFontSize: 15,
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
                      } else {
                        return Container();
                      }
                    },
                  ),
                  checkCodePermision()
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                alignment: AlignmentDirectional.topStart,
                                child: AutoSizeText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    minFontSize: 10,
                                    maxFontSize: 15,
                                    getDeviceLocale() == "ar"
                                        ? "توليد الأكواد"
                                        : "Generate codes",
                                    style: TextStyle(fontSize: 25)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                alignment: AlignmentDirectional.topStart,
                                child: AutoSizeText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    minFontSize: 10,
                                    maxFontSize: 15,
                                    getDeviceLocale() == "ar"
                                        ? "يمكنك توليد الأكواد للتصريح للمستخدمين بالدخول إلى بعض الكورسات التي يطلبونها و كما يمكن إنشاء أكواد للتصريح لبعض المستخدمين لنشر وتحميل الكورسات و إنشاء الأكواد"
                                        : "You can generate codes to authorize users to enter some courses they request, and you can also create codes to authorize some users to publish and download courses and create codes.",
                                    style: TextStyle(fontSize: 15)),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => CodeGenerater(),
                                      ),
                                    );
                                  },
                                  child: AutoSizeText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    minFontSize: 10,
                                    maxFontSize: 15,
                                    getDeviceLocale() == "ar"
                                        ? "توليد الأكواد"
                                        : "Generate codes",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      side: BorderSide(
                                    width: .5,
                                  )),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => RecordCodes(),
                                      ),
                                    );
                                  },
                                  child: AutoSizeText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    minFontSize: 10,
                                    maxFontSize: 15,
                                    getDeviceLocale() == "ar"
                                        ? "سجل الأكواد"
                                        : "Record codes",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      side: BorderSide(
                                    width: .5,
                                  )),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: AlignmentDirectional.topStart,
                      child: AutoSizeText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          minFontSize: 10,
                          maxFontSize: 15,
                          getDeviceLocale() == "ar"
                              ? "تسجيل الخروج"
                              : "Sign out",
                          style: TextStyle(
                            fontSize: 25,
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: AlignmentDirectional.topStart,
                      child: AutoSizeText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          minFontSize: 10,
                          maxFontSize: 15,
                          getDeviceLocale() == "ar"
                              ? "يمكنك تسجيل الخروج من حسابك في أي وقت . بمجرّد قيامك بذلك لن تتمكّن من الدخول إلى التطبيق حتى تسجل الدخول مرة أخرى أو تنشئ حساب جديد"
                              : "You can sign out of your account at any time. Once you do, you will not be able to access the app until you sign in again or create a new account.",
                          style: TextStyle(fontSize: 15)),
                    ),
                  ),
                  BlocBuilder<LunchLoadingCubit, LunchLoadingState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor:
                                  mode ? nightBar["orange"] : dayBar["blue"],
                              content: Container(
                                width: getWidth(context) / 4,
                                height: getHeight(context) / 8,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    AutoSizeText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      minFontSize: 10,
                                      maxFontSize: 15,
                                      getDeviceLocale() == "ar"
                                          ? "هل أنت متأكد ؟"
                                          : "Are you sure?",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            if (await checkConnection()) {
                                              context
                                                  .read<LunchLoadingCubit>()
                                                  .lunchLoading(true);

                                              await _reauthenticateAndDelete();
                                              context
                                                  .read<LunchLoadingCubit>()
                                                  .lunchLoading(false);
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        PageVeiwScreen(),
                                                  ));
                                              var box = Hive.box(hiveBoxName);
                                              box.delete(isStudent);
                                              box.delete(isMainManager);
                                              box.delete(isManager);
                                              box.delete(isCode);
                                              box.delete(isFile);
                                              box.delete("info");
                                              mode = false;

                                              BlocProvider.of<ThemModeCubit>(
                                                      context)
                                                  .isDarkMode(mode);
                                              Future.delayed(
                                                  Duration(seconds: 1),
                                                  () async {
                                                await initUserInfo();
                                              });
                                              BlocProvider.of<ThemModeCubit>(
                                                      context)
                                                  .isDarkMode(false);
                                              BlocProvider.of<ThemModeCubit>(
                                                      context)
                                                  .changeLanguage(false);
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
                                          child: AutoSizeText(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            minFontSize: 10,
                                            maxFontSize: 15,
                                            getDeviceLocale() == "ar"
                                                ? "نعم"
                                                : "Yes",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: AutoSizeText(
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              minFontSize: 10,
                                              maxFontSize: 15,
                                              getDeviceLocale() == "ar"
                                                  ? "إلغاء"
                                                  : "Cancel",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: AutoSizeText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          minFontSize: 10,
                          maxFontSize: 15,
                          getDeviceLocale() == "ar"
                              ? "تسجيل الخروج"
                              : "Sign out",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            side: BorderSide(
                          width: .5,
                        )),
                      );
                    },
                  ),
                  !checkManager()
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: AlignmentDirectional.topStart,
                            child: AutoSizeText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                minFontSize: 10,
                                maxFontSize: 15,
                                getDeviceLocale() == "ar"
                                    ? "تغيير كلمة السر"
                                    : "Change password",
                                style: TextStyle(fontSize: 25)),
                          ),
                        )
                      : Container(),
                  !checkManager()
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: AlignmentDirectional.topStart,
                            child: AutoSizeText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                minFontSize: 10,
                                maxFontSize: 15,
                                getDeviceLocale() == "ar"
                                    ? "يمكنك تغيير كلمة السر إذا لاحظت شبهات في حسابك. يرجى تغيير كلمة السر للحفاظ على الحساب"
                                    : "You can change your password if you notice any suspicious activity in your account. Please change your password to keep your account safe.",
                                style: TextStyle(fontSize: 15)),
                          ),
                        )
                      : Container(),
                  !checkManager()
                      ? ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => UpdatePassword(),
                              ),
                            );
                          },
                          child: AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            getDeviceLocale() == "ar"
                                ? "تغيير كلمة السر"
                                : "Change password",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                              side: BorderSide(
                            width: .5,
                          )),
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: AlignmentDirectional.topStart,
                      child: AutoSizeText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          minFontSize: 10,
                          maxFontSize: 15,
                          getDeviceLocale() == "ar"
                              ? "إعدادت أخرى"
                              : "Other settings",
                          style: TextStyle(fontSize: 25)),
                    ),
                  ),
                  SwitchListTile(
                    value: mode,
                    activeColor: mode
                        ? nightBar["orange"]
                        : const Color.fromARGB(255, 11, 85, 145),
                    onChanged: (value) async {
                      mode = mode ? false : true;

                      BlocProvider.of<ThemModeCubit>(context).isDarkMode(mode);
                      Future.delayed(Duration(seconds: 1), () async {
                        await initUserInfo();
                      });
                    },
                    title: AutoSizeText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 10,
                      maxFontSize: 15,
                      getDeviceLocale() == "ar" ? "الوضع الليلي" : "Night mode",
                      style: TextStyle(),
                    ),
                  ),
                  SwitchListTile(
                    value: getDeviceLocale() == "ar" ? false : true,
                    activeColor: mode
                        ? nightBar["orange"]
                        : const Color.fromARGB(255, 11, 85, 145),
                    onChanged: (value) async {
                      language = value;

                      BlocProvider.of<ThemModeCubit>(context)
                          .changeLanguage(language);
                      Future.delayed(Duration(seconds: 1), () async {
                        await initUserInfo();
                      });
                      var data = await Sql().getLan();
                      if (data.isEmpty) {
                        await Sql().lunchEn();
                      } else {
                        await Sql()
                            .updateLan(language == "ar" ? "false" : "true");
                      }
                    },
                    title: AutoSizeText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 10,
                      maxFontSize: 15,
                      getDeviceLocale() == "ar"
                          ? "اللغة الإنكليزية"
                          : "English language",
                      style: TextStyle(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future initUserInfo() async {
    var hiveInfo = [];
    var info = supabase.auth.currentUser;
    var box = Hive.box(hiveBoxName);

    var checkInternet = await checkConnection();

    if (box.get("info") == null && checkInternet && info != null) {
      var data = await supabase
          .from("current_user")
          .select()
          .eq("email", info.email.toString())
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
