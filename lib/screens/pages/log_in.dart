import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teach/cubit/change_code/code_changed_cubit.dart';
import 'package:teach/cubit/loading_pdf/loading_pdf_cubit.dart';
import 'package:teach/cubit/password/password_cubit.dart';
import 'package:teach/cubit/teachCubit/teach_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/modules/translate_consts.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/main.dart';

import 'package:teach/screens/pages/student_main_screen.dart';

class LogIn extends StatefulWidget {
  var userName1 = "",
      userPhone1 = "",
      userEmail1 = "",
      userCode1 = "",
      userPassword1 = "";
  var codeController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var universityNumberController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var isVisible = false;
  LogIn(
      {required this.userName1,
      required this.userPhone1,
      required this.userEmail1,
      required this.userPassword1,
      required this.userCode1});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  var isLoading = false;

  GlobalKey<FormState> globalKey = GlobalKey();
  @override
  void initState() {
    widget.codeController.text = widget.userCode1;
    widget.nameController.text = widget.userName1;
    widget.phoneController.text = widget.userPhone1;
    widget.emailController.text = widget.userEmail1;
    widget.passwordController.text = widget.userPassword1;
    super.initState();
  }

  String? selectedValue;
  var id;
  Object? selectedCollage;
  String? previusGrade;
  String? previusCollage;
  String? selectedGrade;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30))),
        centerTitle: true,
        title: AutoSizeText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          minFontSize: 10,
          maxFontSize: 15,
          getDeviceLocale() == "ar"
              ? Translation().translateMe["Arabic"]!["Log_in"]
              : Translation().translateMe["English"]!["Log_in"],
        ),
        leading: IconButton(
            onPressed: () {
              context.read<PasswordCubit>().changePasswordVisibility(false);
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: PopScope(
        canPop: true,
        child: SafeArea(
            child: SingleChildScrollView(
          child: Form(
            key: globalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Image.asset("images/log_in.png"),
                ),
                selectedPublicAcount != 1 && selectedPublicAcount != 2
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (value) {
                            return customNameValidator(value!);
                          },
                          controller: widget.nameController,
                          keyboardType: TextInputType.name,
                          cursorColor: dayBar["blue"],
                          onChanged: (name) {
                            widget.userName1 = name;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    width: .5, color: dayBar["blue"])),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    width: .5, color: dayBar["blue"])),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    width: 1, color: dayBar["blue"])),
                            hintText: getDeviceLocale() == "ar"
                                ? "اكتب الاسم الكامل هنا ..."
                                : "Write full name here...",
                            hintStyle: TextStyle(),
                            prefixIcon: Icon(
                              Icons.person,
                              color: dayBar["blue2"],
                            ),
                          ),
                          style: TextStyle(color: dayBar["blue"]),
                        ),
                      )
                    : Container(),
                selectedPublicAcount != 1 && selectedPublicAcount != 2
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (value) {
                            return phoneValidator(value!);
                          },
                          controller: widget.phoneController,
                          keyboardType: TextInputType.phone,
                          onChanged: (phone) {
                            widget.userPhone1 = phone;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    width: .5, color: dayBar["blue"])),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    width: .5, color: dayBar["blue"])),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    width: 1, color: dayBar["blue"])),
                            hintText: getDeviceLocale() == "ar"
                                ? Translation().translateMe["Arabic"]!["phone"]
                                : Translation()
                                    .translateMe["English"]!["phone"],
                            hintStyle: TextStyle(),
                            prefixIcon: Icon(
                              Icons.phone,
                              color: dayBar["blue2"],
                            ),
                          ),
                          style: TextStyle(color: dayBar["blue"]),
                        ),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      return phoneValidator(value!);
                    },
                    controller: widget.universityNumberController,
                    keyboardType: TextInputType.number,
                    cursorColor: dayBar["blue"],
                    onChanged: (name) {
                      widget.universityNumberController.text = name;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(width: .5, color: dayBar["blue"])),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(width: .5, color: dayBar["blue"])),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(width: 1, color: dayBar["blue"])),
                      hintText: getDeviceLocale() == "ar"
                          ? "اكتب رقمك الجامعي هنا..."
                          : "Write your university number here...",
                      hintStyle: TextStyle(),
                      prefixIcon: Icon(
                        Icons.numbers,
                        color: dayBar["blue2"],
                      ),
                    ),
                    style: TextStyle(color: dayBar["blue"]),
                  ),
                ),
                FutureBuilder(
                    future: getTruthSubject(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: mode ? Colors.white : dayBar["blue2"],
                          ),
                        );
                      } else {
                        var data = snapshot.data;

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              buttonStyleData: ButtonStyleData(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: mode
                                            ? Colors.white
                                            : dayBar["blue2"],
                                      ),
                                      borderRadius: BorderRadius.circular(20))),
                              hint: AutoSizeText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                minFontSize: 10,
                                maxFontSize: 15,
                                getDeviceLocale() == "ar"
                                    ? "اختر الدرجة العلمية : "
                                    : "Choose the academic degree : ",
                              ),
                              items: getDeviceLocale() == "ar"
                                  ? (data)!
                                      .map((String value) => DropdownMenuItem(
                                            child: AutoSizeText(
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                minFontSize: 10,
                                                maxFontSize: 15,
                                                value),
                                            value: value,
                                          ))
                                      .toList()
                                  : (data)!
                                      .map((String value) => DropdownMenuItem(
                                            child: AutoSizeText(
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                minFontSize: 10,
                                                maxFontSize: 15,
                                                value),
                                            value: value,
                                          ))
                                      .toList(),
                              value: selectedGrade != null
                                  ? previusGrade != selectedValue
                                      ? data[0]
                                      : selectedGrade
                                  : selectedGrade,
                              onChanged: (value) {
                                setState(() {
                                  selectedGrade = value;
                                  previusGrade = selectedValue;

                                  id = universety.where(
                                    (element) => element.name == value,
                                  );
                                });
                              },
                              dropdownStyleData: DropdownStyleData(
                                  decoration: BoxDecoration(
                                color: mode ? nightBar["orange"] : Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              )),
                            ),
                          ),
                        );
                      }
                    }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      return emailValidator(value!);
                    },
                    controller: widget.emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (email) {
                      widget.userEmail1 = email;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(width: .5, color: dayBar["blue"])),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(width: .5, color: dayBar["blue"])),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(width: 1, color: dayBar["blue"])),
                      hintText: getDeviceLocale() == "ar"
                          ? Translation().translateMe["Arabic"]!["email"]
                          : Translation().translateMe["English"]!["email"],
                      hintStyle: TextStyle(),
                      prefixIcon: Icon(
                        Icons.email,
                        color: dayBar["blue2"],
                      ),
                    ),
                    style: TextStyle(color: dayBar["blue"]),
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
                        controller: widget.passwordController,
                        obscureText:
                            state is VisiblePassword ? !state.isVisible : true,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (password) {
                          widget.userPassword1 = password;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(width: .5, color: dayBar["blue"])),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(width: .5, color: dayBar["blue"])),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(width: 1, color: dayBar["blue"])),
                          hintText: getDeviceLocale() == "ar"
                              ? Translation().translateMe["Arabic"]!["password"]
                              : Translation()
                                  .translateMe["English"]!["password"],
                          hintStyle: TextStyle(),
                          prefixIcon: IconButton(
                            onPressed: () {
                              context
                                  .read<PasswordCubit>()
                                  .changePasswordVisibility(!widget.isVisible);
                              widget.isVisible = !widget.isVisible;
                            },
                            icon: Icon(
                              state is VisiblePassword && state.isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: dayBar["blue2"],
                            ),
                          ),
                        ),
                        style: TextStyle(color: dayBar["blue"]),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<PasswordCubit, PasswordState>(
                    builder: (context, state) {
                      return TextFormField(
                        validator: (value) {
                          return confirmPassword(
                              widget.passwordController.text.trim(),
                              value!.trim());
                        },
                        controller: widget.confirmPasswordController,
                        obscureText:
                            state is VisiblePassword ? !state.isVisible : true,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(width: .5, color: dayBar["blue"])),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(width: .5, color: dayBar["blue"])),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(width: 1, color: dayBar["blue"])),
                          hintText: getDeviceLocale() == "ar"
                              ? "تأكيد كلمة السر..."
                              : "Confirm password...",
                          hintStyle: TextStyle(),
                          prefixIcon: IconButton(
                            onPressed: () {
                              context
                                  .read<PasswordCubit>()
                                  .changePasswordVisibility(!widget.isVisible);
                              widget.isVisible = !widget.isVisible;
                            },
                            icon: Icon(
                              state is VisiblePassword && state.isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: dayBar["blue2"],
                            ),
                          ),
                        ),
                        style: TextStyle(color: dayBar["blue"]),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: BlocBuilder<LoadingPdfCubit, LoadingPdfState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () async {
                          if (globalKey.currentState!.validate()) {
                            if (selectedGrade != null) {
                              try {
                                context
                                    .read<LoadingPdfCubit>()
                                    .loadingPdf(true);
                                final _mobileDeviceIdentifier =
                                    await MobileDeviceIdentifier()
                                        .getDeviceId();
                                await BlocProvider.of<TeachCubit>(context)
                                    .createNewUser({
                                  "name": widget.nameController.text
                                      .trim()
                                      .toString(),
                                  "codes": [],
                                  "email": widget.emailController.text.trim(),
                                  "phone_number": widget.phoneController.text
                                      .trim()
                                      .toString(),
                                  "university_number": widget
                                      .universityNumberController.text
                                      .trim(),
                                  "category": selectedGrade.toString(),
                                  "deviceId":
                                      _mobileDeviceIdentifier.toString(),
                                  "password":
                                      widget.passwordController.text.trim(),
                                },
                                        widget.passwordController.text.trim(),
                                        widget.emailController.text.trim(),
                                        widget.userName1);
                                var box = Hive.box(hiveBoxName);
                                box.put(isStudent, true);
                                box.put(isManager, false);
                                box.put(isMainManager, false);
                                context
                                    .read<LoadingPdfCubit>()
                                    .loadingPdf(false);
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StudentMainScreen(),
                                    ),
                                    (Route<dynamic> route) => false);
                              } catch (error) {
                                context
                                    .read<LoadingPdfCubit>()
                                    .loadingPdf(false);
                                if (error is AuthException) {
                                  switch (error.statusCode) {
                                    case "400":
                                      if (error.message.contains(
                                          'Invalid login credentials')) {
                                        lunchAwesomDialoge(
                                          DialogType.error,
                                          "e",
                                          getDeviceLocale() == "ar"
                                              ? "كلمة السر خاطئة!"
                                              : "Wrong password!",
                                          context,
                                          getWidth(context),
                                          getHeight(context),
                                        );
                                      } else {
                                        lunchAwesomDialoge(
                                          DialogType.error,
                                          "e",
                                          getDeviceLocale() == "ar"
                                              ? "بيانات الدخول غير صحيحة!"
                                              : "Invalid credentials!",
                                          context,
                                          getWidth(context),
                                          getHeight(context),
                                        );
                                      }
                                      break;
                                    case "404":
                                      lunchAwesomDialoge(
                                        DialogType.error,
                                        "e",
                                        getDeviceLocale() == "ar"
                                            ? "البريد الإلكتروني غير مسجل!"
                                            : "Email not found!",
                                        context,
                                        getWidth(context),
                                        getHeight(context),
                                      );
                                      break;
                                    default:
                                      lunchAwesomDialoge(
                                        DialogType.error,
                                        "e",
                                        getDeviceLocale() == "ar"
                                            ? "حدث خطأ غير متوقع!"
                                            : "An unexpected error occurred!",
                                        context,
                                        getWidth(context),
                                        getHeight(context),
                                      );
                                  }
                                }
                              }
                            } else {
                              context.read<LoadingPdfCubit>().loadingPdf(false);
                              lunchAwesomDialoge(
                                  DialogType.error,
                                  "e",
                                  getDeviceLocale() == "ar"
                                      ? "يرجى اختيار مستواك الدراسي"
                                      : "Please select your level of study",
                                  context,
                                  getWidth(context),
                                  getHeight(context));
                            }
                          }
                        },
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: state is LoadingPdf && state.loading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : AutoSizeText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  minFontSize: 10,
                                  maxFontSize: 15,
                                  getDeviceLocale() == "ar"
                                      ? "تسجيل الدخول"
                                      : "Sign in",
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }

  Future<Map<String, dynamic>> fetchMyData(grade) async {
    print(grade);
    if (grade <= 6) {
      Map<String, dynamic> primary = {};

      var data = await supabase
          .from("folders")
          .select()
          .filter("parent_id", "is", null);

      for (var i = 0; i < data.length; i++) {
        if (primaryInArabic.contains(data[i]["name"]) ||
            primaryInEnglish.contains(data[i]["name"])) {
          primary.addAll(data[i]);
        }
      }
      return primary;
    } else if (grade <= 9) {
      Map<String, dynamic> preparatory = {};

      var data = await supabase
          .from("folders")
          .select()
          .filter("parent_id", "is", null);

      for (var i = 0; i < data.length; i++) {
        if (preparatoryInArabic.contains(data[i]["name"]) ||
            preparatoryInEnglish.contains(data[i]["name"])) {
          preparatory.addAll(data[i]);
        }
      }
      return preparatory;
    } else if (grade <= 12) {
      Map<String, dynamic> secondary = {};

      var data = await supabase
          .from("folders")
          .select()
          .filter("parent_id", "is", null);

      for (var i = 0; i < data.length; i++) {
        if (secondaryInArabic.contains(data[i]["name"]) ||
            secondaryInEnglish.contains(data[i]["name"])) {
          secondary.addAll(data[i]);
        }
      }
      return secondary;
    } else {
      Map<String, dynamic> university = {};

      var data = await supabase
          .from("folders")
          .select()
          .filter("parent_id", "is", null);

      for (var i = 0; i < data.length; i++) {
        if (!school.contains(data[i]["name"])) {
          university.addAll(data[i]);
        }
      }

      return university;
    }
  }
}
