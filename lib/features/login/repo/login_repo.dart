import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teach/cubit/teachCubit/teach_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/features/login/presentation/manager/login_loading/login_loading_cubit.dart';
import 'package:teach/features/student-main-screen/presentation/student_main_screen.dart';

class LoginRepo {
  createNewUser(
    context,
    name,
    email,
    phone,
    universityNumber,
    selectedGrade,
  
    password,
  ) async {

 try {
                              
                                context
                                    .read<LoginLoadingCubit>()
                                    .lunchLoading();
                                final mobileDeviceIdentifier =
                                    await MobileDeviceIdentifier()
                                        .getDeviceId();
                                await BlocProvider.of<TeachCubit>(context)
                                    .createNewUser({
                                  "name": name
                                     ,
                                  "codes": [],
                                  "email": email,
                                  "phone_number": phone,
                                  "university_number": universityNumber,
                                  "category": selectedGrade.toString(),
                                  "deviceId":
                                      mobileDeviceIdentifier.toString(),
                                  "password":
                                      password,
                                },
                                        password,
                                        email,
                                       name);
                                var box = Hive.box(hiveBoxName);
                                box.put(isStudent, true);
                                box.put(isManager, false);
                                box.put(isMainManager, false);
                                context
                                    .read<LoginLoadingCubit>()
                                    .stope();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const StudentMainScreen(),
                                    ),
                                    (Route<dynamic> route) => false);
                              } catch (error) {
                                context
                                    .read<LoginLoadingCubit>()
                                    .stope();
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


  }
}
