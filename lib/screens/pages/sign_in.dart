import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gotrue/src/types/auth_response.dart';
import 'package:hive/hive.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teach/cubit/changeOpacity/change_opacity_cubit.dart';
import 'package:teach/cubit/change_code/code_changed_cubit.dart';
import 'package:teach/cubit/password/password_cubit.dart';
import 'package:teach/cubit/teachCubit/teach_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/modules/translate_consts.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/main.dart';
import 'package:teach/screens/main_screen.dart';
import 'package:teach/screens/pages/bar_code_scanner.dart';
import 'package:teach/screens/pages/student_main_screen.dart';

class SignUp extends StatefulWidget {
  var is_loading = false;
  var isVisible = false;
  var userCode = "";
  var isCodeEnter = false;
  var codeController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  SignUp(
      {required this.emailController,
      required this.passwordController,
      required this.codeController});
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var userEmail = "", userPassword = "";
  GlobalKey<FormState> globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          getDeviceLocale() == "ar"
              ? Translation().translateMe["Arabic"]!["Log_in"]
              : Translation().translateMe["English"]!["Log_in"],
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset("images/log_in.png"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      return emailValidator(value!);
                    },
                    controller: widget.emailController,
                    cursorColor: dayBar["blue"],
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (email) {
                      userEmail = email;
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
                          ? "اكتب البريد الإلكتروني هنا..."
                          : "Type your email here...",
                      hintStyle: TextStyle(),
                      prefixIcon: Icon(
                        Icons.person,
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
                        validator: (password) {
                          return newPasswordValidator(password!);
                        },
                        obscureText:
                            state is VisiblePassword ? !state.isVisible : true,
                        keyboardType: TextInputType.visiblePassword,
                        cursorColor: dayBar["blue"],
                        onChanged: (password) {
                          userPassword = password;
                        },
                        controller: widget.passwordController,
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
                                widget.isVisible = !widget.isVisible;
                                context
                                    .read<PasswordCubit>()
                                    .changePasswordVisibility(widget.isVisible);
                              },
                              icon: Icon(
                                  state is VisiblePassword && state.isVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: dayBar["blue2"])),
                        ),
                        style: TextStyle(color: dayBar["blue"]),
                      );
                    },
                  ),
                ),
                BlocBuilder<ChangeOpacityCubit, ChangeOpacityState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        CheckboxListTile(
                            activeColor: Colors.blue,
                            title: Text(getDeviceLocale() == "ar"
                                ? "لدي كود تصريح دخول"
                                : "I have an entry permit code."),
                            value: state is ChangeOpacity
                                ? state.opacity == 1.0
                                : false,
                            onChanged: (value) {
                              if (value!) {
                                context
                                    .read<ChangeOpacityCubit>()
                                    .changeOpacity(1.0);
                              } else {
                                context
                                    .read<ChangeOpacityCubit>()
                                    .changeOpacity(0.0);
                              }
                            }),
                        Opacity(
                          opacity: state is ChangeOpacity ? state.opacity : 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                BlocBuilder<CodeChangedCubit, CodeChangedState>(
                              builder: (context, state) {
                                if (state is ChangeCode) {
                                  return TextFormField(
                                    controller: widget.codeController,
                                    keyboardType: TextInputType.name,
                                    onChanged: (code) {
                                      widget.userCode = code;
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                              width: .5,
                                              color: dayBar["blue"])),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                              width: .5,
                                              color: dayBar["blue"])),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                              width: 1, color: dayBar["blue"])),
                                      hintText: getDeviceLocale() == "ar"
                                          ? Translation()
                                              .translateMe["Arabic"]!["code_r"]
                                          : Translation().translateMe[
                                              "English"]!["code_r"],
                                      hintStyle: TextStyle(),
                                      prefixIcon: IconButton(
                                        onPressed: () async {
                                          var code = await Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                BarCodeScanner(
                                              userEmail1: userEmail,
                                              userPassword1: userPassword,
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
                                    controller: widget.codeController,
                                    keyboardType: TextInputType.name,
                                    onChanged: (code) {
                                      widget.userCode = code;
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                              width: .5,
                                              color: dayBar["blue"])),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                              width: .5,
                                              color: dayBar["blue"])),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                              width: 1, color: dayBar["blue"])),
                                      hintText: getDeviceLocale() == "ar"
                                          ? Translation()
                                              .translateMe["Arabic"]!["code_r"]
                                          : Translation().translateMe[
                                              "English"]!["code_r"],
                                      hintStyle: TextStyle(),
                                      prefixIcon: IconButton(
                                        onPressed: () async {
                                          var code = await Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                BarCodeScanner(
                                              userEmail1: userEmail,
                                              userPassword1: userPassword,
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
                          ),
                        ),
                      ],
                    );
                  },
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (globalKey.currentState!.validate()) {
                        if (widget.codeController.text.isEmpty) {
                          try {
                            setState(() {
                              widget.is_loading = true;
                            });
                            late AuthResponse user;
                            try {
                              user = await supabase.auth.signInWithPassword(
                                email: userEmail,
                                password: userPassword,
                              );
                              // Success case
                            } catch (error) {
                              if (error is AuthException) {
                                setState(() {
                                  widget.is_loading = false;
                                });
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
                              } else {
                                lunchAwesomDialoge(
                                  DialogType.error,
                                  "e",
                                  getDeviceLocale() == "ar"
                                      ? "حدث خطأ في الشبكة!"
                                      : "Network error occurred!",
                                  context,
                                  getWidth(context),
                                  getHeight(context),
                                );
                              }
                              return null;
                            }
                            var email = user.user!.email;
                            var mainManager = await supabase
                                .from('main_manager')
                                .select()
                                .eq("id", 1)
                                .maybeSingle();

                            if (userEmail == mainManager!["email"]) {
                              var box = Hive.box(hiveBoxName);

                              box.put(isMainManager, true);
                            }
                            var box = Hive.box(hiveBoxName);

                            if (box.get(isMainManager) == null) {
                              final _mobileDeviceIdentifier =
                                  await MobileDeviceIdentifier().getDeviceId();
                              var userData = await supabase
                                  .from('current_user')
                                  .select()
                                  .eq('id', user.user!.id)
                                  .maybeSingle();

                              if (userData != null) {
                                var deviceId = await userData["deviceId"];

                                if (deviceId == _mobileDeviceIdentifier ||
                                    deviceId.isEmpty) {
                                  box.put(isStudent, true);
                                  box.put(isMainManager, false);
                                  box.put(isManager, false);
                                  if (deviceId == "") {
                                    await supabase.from("current_user").update({
                                      "deviceId": _mobileDeviceIdentifier
                                    }).eq("email", email.toString());
                                  }
                                  setState(() {
                                    widget.is_loading = false;
                                  });
                                  box.put("student_name", userData["name"]);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            StudentMainScreen(),
                                      ));
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
                                  setState(() {
                                    widget.is_loading = false;
                                  });
                                }
                              } else {
                                setState(() {
                                  widget.is_loading = false;
                                });
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
                              setState(() {
                                widget.is_loading = false;
                              });
                              box.put(isStudent, false);
                              box.put(isManager, false);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainScreen(),
                                  ));
                            }
                          } catch (e) {
                            print(e);
                            setState(() {
                              widget.is_loading = false;
                            });
                          }
                        } else {
                          setState(() {
                            widget.is_loading = true;
                          });

                          try {
                            setState(() {
                              widget.is_loading = true;
                            });

                            var user = await supabase.auth.signInWithPassword(
                              email: userEmail,
                              password: userPassword,
                            );

                            var email = user.user?.email;
                            var data = await supabase
                                .from("manager")
                                .select()
                                .eq("email", email.toString())
                                .eq("code", widget.codeController.text)
                                .maybeSingle();

                            if (data != null) {
                              setState(() {
                                widget.is_loading = false;
                              });
                              var box = Hive.box(hiveBoxName);
                              box.put(isManager, true);
                              box.put(isMainManager, false);
                              box.put(isStudent, false);
                              box.put(isCode, data["codeP"]);
                              box.put(isFile, data["file"]);
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainScreen(),
                                  ),
                                  (Route<dynamic> route) => false);
                            } else {
                              setState(() {
                                widget.is_loading = false;
                              });
                              await supabase.auth.signOut();
                              lunchAwesomDialoge(
                                  DialogType.error,
                                  "e",
                                  getDeviceLocale() == "ar"
                                      ? "الكود غير صالح"
                                      : "The code is invalid",
                                  context,
                                  getWidth(context),
                                  getHeight(context));
                            }
                            // Handle successful login here
                          } catch (error) {
                            setState(() {
                              widget.is_loading = false;
                            });

                            if (error.toString().contains(
                                "The password is invalid or the user does not have a password.")) {
                              lunchAwesomDialoge(
                                  DialogType.error,
                                  "e",
                                  getDeviceLocale() == "ar"
                                      ? "كلمة السر خاطئة!"
                                      : "Wrong password!",
                                  context,
                                  getWidth(context),
                                  getHeight(context));
                            } else if (error.toString().contains("emai")) {
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
                    },
                    style: ElevatedButton.styleFrom(),
                    child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: widget.is_loading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                getDeviceLocale() == "ar"
                                    ? Translation()
                                        .translateMe["Arabic"]!["Log_in"]
                                    : Translation()
                                        .translateMe["English"]!["Log_in"],
                                style: TextStyle(color: Colors.white),
                              )))
              ],
            ),
          ),
        )),
      ),
    );
  }
}
