import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teach/cubit/animatedContainerTow/animated_container_tow_cubit.dart';
import 'package:teach/cubit/lunch_loading_cubit/lunch_loading_cubit.dart';
import 'package:teach/cubit/password/password_cubit.dart';
import 'package:teach/cubit/search_code/selected_code_search_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/widgets/lunch.dart';

class CodeGenerater extends StatefulWidget {
  var isVisible = true;
  var managerName = "",
      managerPhone = "",
      managerEmail = "",
      managerPassword = "",
      filePermision = false,
      codePermision = false,
      watchPermision = false,
      editePermision = false,
      notificationPermission = false,
      deletePermision = false;
  var manager = true;
  var codes = false;
  var curseName = "", numberOfCodes = 0, cate = "";
  List<String> courses = [];
  @override
  State<CodeGenerater> createState() => _CodeGeneraterState();
}

class _CodeGeneraterState extends State<CodeGenerater> {
  GlobalKey<FormState> globalKey = GlobalKey();
  GlobalKey<FormState> globalKeyCode = GlobalKey();

  @override
  void initState() {
    fetchCourses().then((fetchedCourses) {
      setState(() {
        widget.courses = fetchedCourses;
      });
    });
    super.initState();
  }

  String? selectedCode;
  final TextEditingController searchEditingController = TextEditingController();

  @override
  void dispose() {
    searchEditingController.dispose();
    super.dispose();
  }

  var box = Hive.box(hiveBoxName);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mode ? nightBar["orange"] : dayBar["blue3"],
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: getWidth(context) * .4,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(getWidth(context) * .05),
                    child: SizedBox(
                        width: getWidth(context) * .15,
                        height: getWidth(context) * .15,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              "images/icon.jpg",
                              width: getWidth(context),
                              fit: BoxFit.cover,
                            ))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: AlignmentDirectional.topStart,
                      child: Center(
                        child: AutoSizeText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          minFontSize: 10,
                          maxFontSize: 15,
                          getDeviceLocale() == "ar"
                              ? "إنشاء مدير جديد"
                              : "Create new manager",
                          style: TextStyle(
                              fontSize: getWidth(context) * .05,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                height: getHeight(context) - (getWidth(context) * .4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: mode ? Colors.black : Colors.white),
                child: SingleChildScrollView(child: managerBody())),
          ],
        ),
      ),
    );
  }

  Widget managerBody() {
    return Form(
      key: globalKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              validator: (value) {
                return nameValidator(value!);
              },
              cursorColor: mode ? Colors.white : dayBar["blue2"],
              onChanged: (value) {
                widget.managerName = value;
              },
              style: TextStyle(
                color: mode
                    ? Colors.white
                    : const Color.fromARGB(255, 11, 85, 145),
              ),
              decoration: InputDecoration(
                hintText: getDeviceLocale() == "ar"
                    ? "اسم المدير..."
                    : "Manager name...",
                prefixIcon: Icon(
                  Icons.person,
                  color: mode ? Colors.white : dayBar["blue2"],
                ),
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
            child: TextFormField(
              validator: (value) {
                return phoneValidator(value!);
              },
              cursorColor: mode ? Colors.white : dayBar["blue2"],
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                widget.managerPhone = value;
              },
              style: TextStyle(
                  color: mode
                      ? Colors.white
                      : const Color.fromARGB(255, 11, 85, 145)),
              decoration: InputDecoration(
                hintText:
                    getDeviceLocale() == "ar" ? "رقم الهاتف ..." : "Phone...",
                prefixIcon: Icon(
                  Icons.phone,
                  color: mode ? Colors.white : dayBar["blue2"],
                ),
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
            child: TextFormField(
              validator: (value) {
                return emailValidator(value!);
              },
              cursorColor: mode ? Colors.white : dayBar["blue2"],
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                widget.managerEmail = value;
              },
              style: TextStyle(
                  color: mode
                      ? Colors.white
                      : const Color.fromARGB(255, 11, 85, 145)),
              decoration: InputDecoration(
                hintText: getDeviceLocale() == "ar"
                    ? "البريد الإلكتروني ..."
                    : "Email...",
                prefixIcon: Icon(
                  Icons.email,
                  color: mode ? Colors.white : dayBar["blue2"],
                ),
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
            child: BlocBuilder<PasswordCubit, PasswordState>(
              builder: (context, state) {
                return TextFormField(
                  validator: (value) {
                    return newPasswordValidator(value!);
                  },
                  cursorColor: mode ? Colors.white : dayBar["blue2"],
                  obscureText:
                      state is VisiblePassword ? state.isVisible : true,
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (value) {
                    widget.managerPassword = value;
                  },
                  style: TextStyle(
                      color: mode
                          ? Colors.white
                          : const Color.fromARGB(255, 11, 85, 145)),
                  decoration: InputDecoration(
                    hintText: getDeviceLocale() == "ar"
                        ? "كلمة السر ..."
                        : "Password...",
                    prefixIcon: IconButton(
                      onPressed: () {
                        widget.isVisible = !widget.isVisible;
                        context
                            .read<PasswordCubit>()
                            .changePasswordVisibility(widget.isVisible);
                      },
                      icon: state is VisiblePassword
                          ? state.isVisible
                              ? Icon(
                                  Icons.visibility_off,
                                  color: mode ? Colors.white : dayBar["blue2"],
                                )
                              : Icon(
                                  Icons.visibility,
                                  color: mode ? Colors.white : dayBar["blue2"],
                                )
                          : Icon(
                              Icons.visibility_off,
                              color: mode ? Colors.white : dayBar["blue2"],
                            ),
                    ),
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
                );
              },
            ),
          ),
          BlocBuilder<PasswordCubit, PasswordState>(
            builder: (context, state) {
              return Column(
                children: [
                  SwitchListTile(
                    activeColor: mode
                        ? nightBar["orange"]
                        : const Color.fromARGB(255, 11, 85, 145),
                    value: state is FilePermisions
                        ? state.filePermision
                            ? true
                            : false
                        : false,
                    onChanged: (value) {
                      widget.filePermision = value;
                      context.read<PasswordCubit>().changePermision(
                          value,
                          widget.codePermision,
                          widget.watchPermision,
                          widget.editePermision,
                          widget.deletePermision, widget.notificationPermission);
                    },
                    title: AutoSizeText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 10,
                      maxFontSize: 15,
                      getDeviceLocale() == "ar"
                          ? "صلاحيات ترفيع الملفات"
                          : "File upload permissions",
                      style: TextStyle(),
                    ),
                  ),
                  SwitchListTile(
                    activeColor: mode
                        ? nightBar["orange"]
                        : const Color.fromARGB(255, 11, 85, 145),
                    value: state is FilePermisions
                        ? state.watchPermition
                            ? true
                            : false
                        : false,
                    onChanged: (value) {
                      widget.watchPermision = value;
                      context.read<PasswordCubit>().changePermision(
                          widget.filePermision,
                          widget.codePermision,
                          value,
                          widget.editePermision,
                          widget.deletePermision, widget.notificationPermission);
                    },
                    title: AutoSizeText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 10,
                      maxFontSize: 15,
                      getDeviceLocale() == "ar"
                          ? "صلاحيات مشاهدة الملفات"
                          : "File upload permissions",
                      style: TextStyle(),
                    ),
                  ),
                  SwitchListTile(
                    activeColor: mode
                        ? nightBar["orange"]
                        : const Color.fromARGB(255, 11, 85, 145),
                    value: state is FilePermisions
                        ? state.editPermition
                            ? true
                            : false
                        : false,
                    onChanged: (value) {
                      widget.editePermision = value;
                      context.read<PasswordCubit>().changePermision(
                          widget.filePermision,
                          widget.codePermision,
                          widget.watchPermision,
                          value,
                          widget.deletePermision, widget.notificationPermission);
                    },
                    title: AutoSizeText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 10,
                      maxFontSize: 15,
                      getDeviceLocale() == "ar"
                          ? "صلاحيات تعديل الملفات"
                          : "File upload permissions",
                      style: TextStyle(),
                    ),
                  ),
                  SwitchListTile(
                    activeColor: mode
                        ? nightBar["orange"]
                        : const Color.fromARGB(255, 11, 85, 145),
                    value: state is FilePermisions
                        ? state.note
                            ? true
                            : false
                        : false,
                    onChanged: (value) {
                      widget.notificationPermission = value;
                      context.read<PasswordCubit>().changePermision(
                          widget.filePermision,
                          widget.codePermision,
                          widget.watchPermision,
                          widget.editePermision,
                          widget.deletePermision, value);
                    },
                    title: AutoSizeText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 10,
                      maxFontSize: 15,
                      getDeviceLocale() == "ar"
                          ? "صلاحيات إرسال إشعارات "
                          :"Notification sending permissions",
                      style: TextStyle(),
                    ),
                  ),
                  SwitchListTile(
                    activeColor: mode
                        ? nightBar["orange"]
                        : const Color.fromARGB(255, 11, 85, 145),
                    value: state is FilePermisions
                        ? state.deletePermition
                            ? true
                            : false
                        : false,
                    onChanged: (value) {
                      widget.deletePermision = value;
                      context.read<PasswordCubit>().changePermision(
                          widget.filePermision,
                          widget.codePermision,
                          widget.watchPermision,
                          widget.editePermision,
                          value, widget.notificationPermission);
                    },
                    title: AutoSizeText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 10,
                      maxFontSize: 15,
                      getDeviceLocale() == "ar"
                          ? "صلاحيات حذف الملفات"
                          : "File upload permissions",
                      style: TextStyle(),
                    ),
                  ),
                  SwitchListTile(
                    activeColor: mode
                        ? nightBar["orange"]
                        : const Color.fromARGB(255, 11, 85, 145),
                    value: state is FilePermisions
                        ? state.codePermesion
                            ? true
                            : false
                        : false,
                    onChanged: (value) {
                      widget.codePermision = value;

                      context.read<PasswordCubit>().changePermision(
                          widget.filePermision,
                          value,
                          widget.watchPermision,
                          widget.editePermision,
                          widget.deletePermision,widget.notificationPermission);
                    },
                    title: AutoSizeText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 10,
                      maxFontSize: 15,
                      getDeviceLocale() == "ar"
                          ? "صلاحيات توليد الأكواد "
                          : "Code generation permissions",
                      style: TextStyle(),
                    ),
                  ),
                ],
              );
            },
          ),
          BlocBuilder<LunchLoadingCubit, LunchLoadingState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (await checkConnection()) {
                      if (!globalKey.currentState!.validate() ||
                          (!widget.filePermision && !widget.codePermision)) {
                        lunchAwesomDialoge(
                            DialogType.error,
                            "e",
                            getDeviceLocale() == "ar"
                                ? "يرجى كتابة جميع المعلومات"
                                : "Please write all information",
                            context,
                            getWidth(context),
                            getHeight(context));
                      } else {
                        try {
                          context.read<LunchLoadingCubit>().lunchLoading(true);
                          await context
                              .read<PasswordCubit>()
                              .createManagerAccount(
                                  name: widget.managerName,
                                  phone: widget.managerPhone,
                                  email: widget.managerEmail,
                                  password: widget.managerPassword,
                                  filePermision: widget.filePermision,
                                  codePermision: widget.codePermision,
                                  watchPermition: widget.watchPermision,
                                  editePermition: widget.editePermision,
                                  deletePermition: widget.deletePermision);
                          context.read<LunchLoadingCubit>().lunchLoading(false);
                          lunchAwesomDialoge(
                              DialogType.success,
                              "s",
                              getDeviceLocale() == "ar"
                                  ? "تمّت العملية بنجاح"
                                  : "The operation was completed successfully.",
                              context,
                              getWidth(context),
                              getHeight(context));
                        } catch (e) {
                          context.read<LunchLoadingCubit>().lunchLoading(false);

                          String errorMessage;
                          if (e is AuthException) {
                            errorMessage =
                                handleAuthError(e, getDeviceLocale());
                          } else if (e is PostgrestException) {
                            errorMessage =
                                handleDatabaseError(e, getDeviceLocale());
                          } else {
                            errorMessage = getDeviceLocale() == "ar"
                                ? "حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى"
                                : "An unexpected error occurred. Please try again";
                          }
                          lunchAwesomDialoge(
                              DialogType.error,
                              "e",
                              errorMessage,
                              context,
                              getWidth(context),
                              getHeight(context));
                        }
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
                  child: state is LunchLoading
                      ? state.loading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : AutoSizeText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              minFontSize: 10,
                              maxFontSize: 15,
                              getDeviceLocale() == "ar" ? "توليد" : "generate",
                              style: TextStyle(color: Colors.white),
                            )
                      : AutoSizeText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          minFontSize: 10,
                          maxFontSize: 15,
                          getDeviceLocale() == "ar" ? "توليد" : "generate",
                          style: TextStyle(color: Colors.white),
                        ),
                  style: ElevatedButton.styleFrom(
                      side: BorderSide(
                    width: .5,
                  )),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
