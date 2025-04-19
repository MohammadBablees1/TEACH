import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hive/hive.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';
import 'package:teach/cubit/change_code/code_changed_cubit.dart';
import 'package:teach/cubit/loading_pdf/loading_pdf_cubit.dart';
import 'package:teach/cubit/password/password_cubit.dart';
import 'package:teach/cubit/teachCubit/teach_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/consts/sql_const.dart';
import 'package:teach/data/modules/translate_consts.dart';
import 'package:teach/data/modules/user.dart';
import 'package:teach/data/modules/user_plus.dart';
import 'package:teach/data/repository/folder_repo.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/main.dart';
import 'package:teach/screens/main_screen.dart';
import 'package:teach/screens/pages/bar_code_scanner.dart';
import 'package:teach/screens/pages/final_step.dart';
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
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
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
        title: Text(
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
        canPop: false,
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
                            return nameValidator(value!);
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
                                ? Translation()
                                    .translateMe["Arabic"]!["welcom_hint"]
                                : Translation()
                                    .translateMe["English"]!["welcom_hint"],
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
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      buttonStyleData: ButtonStyleData(
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: mode ? Colors.white : dayBar["blue2"],
                              ),
                              borderRadius: BorderRadius.circular(20))),
                      hint: Text(
                        getDeviceLocale() == "ar"
                            ? "اختر الفئة المتبوع لها : "
                            : "Choose the category to follow : ",
                      ),
                      items: getDeviceLocale() == "ar"
                          ? itemsInArabic
                              .map((String value) => DropdownMenuItem(
                                    child: Text(value),
                                    value: value,
                                  ))
                              .toList()
                          : itemsInEnglish
                              .map((String value) => DropdownMenuItem(
                                    child: Text(value),
                                    value: value,
                                  ))
                              .toList(),
                      value: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                      dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                        color: mode ? nightBar["orange"] : Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      )),
                    ),
                  ),
                ),
                selectedValue != null
                    ? FutureBuilder(
                        future: getTruthSubject(selectedValue),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  hint: Text(
                                    getDeviceLocale() == "ar"
                                        ? selectedValue == "جامعي" ||
                                                selectedValue ==
                                                    itemsInEnglish[3]
                                            ? "اختر نوع الجامعة"
                                            : "اختر الدرجة العلمية : "
                                        : selectedValue == "جامعي" ||
                                                selectedValue ==
                                                    itemsInEnglish[3]
                                            ? "Choose the type of university"
                                            : "Choose the academic degree : ",
                                  ),
                                  items: getDeviceLocale() == "ar"
                                      ? (data)!
                                          .map((String value) =>
                                              DropdownMenuItem(
                                                child: Text(value),
                                                value: value,
                                              ))
                                          .toList()
                                      : (data)!
                                          .map((String value) =>
                                              DropdownMenuItem(
                                                child: Text(value),
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
                                    color: mode
                                        ? nightBar["orange"]
                                        : Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  )),
                                ),
                              ),
                            );
                          }
                        })
                    : Container(),
                selectedGrade != null &&
                        (selectedValue == "جامعي" ||
                            selectedValue == itemsInEnglish[3])
                    ? FutureBuilder(
                        future: getTruthDegree(selectedGrade, id.first.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  hint: Text(
                                    getDeviceLocale() == "ar"
                                        ? "اختر الدرجة العلمية : "
                                        : "Choose the academic degree : ",
                                  ),
                                  items: getDeviceLocale() == "ar"
                                      ? (data)!
                                          .map((String value) =>
                                              DropdownMenuItem(
                                                child:
                                                    Text(value.split("/").last),
                                                value: value,
                                              ))
                                          .toList()
                                      : (data)!
                                          .map((String value) =>
                                              DropdownMenuItem(
                                                child: Text(value),
                                                value: value,
                                              ))
                                          .toList(),
                                  value: selectedCollage != null
                                      ? previusCollage != selectedGrade
                                          ? data[0].split("/").last
                                          : selectedCollage
                                      : selectedCollage,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCollage = value;
                                      previusCollage = selectedGrade;
                                    });
                                  },
                                  dropdownStyleData: DropdownStyleData(
                                      decoration: BoxDecoration(
                                    color: mode
                                        ? nightBar["orange"]
                                        : Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  )),
                                ),
                              ),
                            );
                          }
                        })
                    : Container(),
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
                selectedPublicAcount == 1
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BlocBuilder<CodeChangedCubit, CodeChangedState>(
                          builder: (context, state) {
                            if (state is ChangeCode) {
                              return TextFormField(
                                validator: (value) {
                                  return codeValidator(value!);
                                },
                                controller: widget.codeController,
                                keyboardType: TextInputType.name,
                                onChanged: (code) {
                                  widget.userCode1 = code;
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
                                      ? Translation()
                                          .translateMe["Arabic"]!["code_r"]
                                      : Translation()
                                          .translateMe["English"]!["code_r"],
                                  hintStyle: TextStyle(),
                                  prefixIcon: IconButton(
                                    onPressed: () async {
                                      var code = await Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => BarCodeScanner(
                                          userEmail1: widget.userEmail1,
                                          userPassword1: widget.userPassword1,
                                          check: true,
                                        ),
                                      ));
                                      context
                                          .read<CodeChangedCubit>()
                                          .changeCode(code);
                                    },
                                    icon: Icon(
                                      Icons.code,
                                      color: dayBar["blue2"],
                                    ),
                                  ),
                                ),
                                style: TextStyle(color: dayBar["blue"]),
                              );
                            } else {
                              return TextFormField(
                                validator: (value) {
                                  return codeValidator(value!);
                                },
                                controller: widget.codeController,
                                keyboardType: TextInputType.name,
                                onChanged: (code) {
                                  widget.userCode1 = code;
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
                                      ? Translation()
                                          .translateMe["Arabic"]!["code_r"]
                                      : Translation()
                                          .translateMe["English"]!["code_r"],
                                  hintStyle: TextStyle(),
                                  prefixIcon: IconButton(
                                    onPressed: () async {
                                      var code = await Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => BarCodeScanner(
                                          userEmail1: widget.userEmail1,
                                          userPassword1: widget.userPassword1,
                                          check: true,
                                        ),
                                      ));
                                      widget.codeController.text = code;
                                      context
                                          .read<CodeChangedCubit>()
                                          .changeCode(code);
                                    },
                                    icon: Icon(
                                      Icons.code,
                                      color: dayBar["blue2"],
                                    ),
                                  ),
                                ),
                                style: TextStyle(color: dayBar["blue"]),
                              );
                            }
                          },
                        ),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: BlocBuilder<LoadingPdfCubit, LoadingPdfState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () async {
                          if (globalKey.currentState!.validate()) {
                            if (selectedValue != null &&
                                selectedGrade != null) {
                              try {
                                context
                                    .read<LoadingPdfCubit>()
                                    .loadingPdf(true);
                                final _mobileDeviceIdentifier =
                                    await MobileDeviceIdentifier()
                                        .getDeviceId();
                                await BlocProvider.of<TeachCubit>(context)
                                    .createNewUser({
                                  "name": widget.userName1.toString(),
                                  "grade": selectedValue.toString(),
                                  "codes": [],
                                  "email": widget.userEmail1,
                                  "phone_number": widget.userPhone1.toString(),
                                  "category": selectedGrade.toString(),
                                  "collage": selectedCollage.toString(),
                                  "deviceId":
                                      _mobileDeviceIdentifier.toString(),
                                }, widget.userPassword1, widget.userEmail1,
                                        widget.userName1);
                                var box = Hive.box(hiveBoxName);
                                box.put(isStudent, true);
                                box.put(isManager, false);
                                box.put(isMainManager, false);
                                context
                                    .read<LoadingPdfCubit>()
                                    .loadingPdf(false);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StudentMainScreen(),
                                    ));
                              } catch (e) {
                                context
                                    .read<LoadingPdfCubit>()
                                    .loadingPdf(false);
                                print(e);
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
                              : Text(
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
