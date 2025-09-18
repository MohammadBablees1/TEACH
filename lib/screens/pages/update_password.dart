import 'package:auto_size_text/auto_size_text.dart';
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

class UpdatePassword extends StatelessWidget {
  var currentPassword = "", newPassword = "";
  GlobalKey<FormState> globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
        centerTitle: true,
        title: AutoSizeText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          minFontSize: 10,
          maxFontSize: 15,
          getDeviceLocale() == "ar" ? "تغيير كلمة المرور" : "Change password",
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
          child: Form(
        key: globalKey,
        child: Column(
          children: [
            Icon(
              Icons.password,
              size: 40,
              color: mode ? Colors.white : dayBar["blue2"],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  return nameValidator(value!);
                },
                style: TextStyle(color: mode ? Colors.white : dayBar["blue2"]),
                cursorColor: mode ? Colors.white : dayBar["blue2"],
                obscureText: true,
                onChanged: (value) {
                  currentPassword = value;
                },
                decoration: InputDecoration(
                  hintText: getDeviceLocale() == "ar"
                      ? "كلمة المرور الحالية : "
                      : "Current Password : ",
                  hintStyle: TextStyle(
                      color: mode
                          ? Colors.white.withOpacity(.5)
                          : dayBar["blue2"].withOpacity(.5)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        width: .5,
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        width: .5,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        width: 1,
                      )),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  return newPasswordValidator(value!);
                },
                style: TextStyle(color: mode ? Colors.white : dayBar["blue2"]),
                cursorColor: mode ? Colors.white : dayBar["blue2"],
                obscureText: true,
                onChanged: (value) {
                  newPassword = value;
                },
                decoration: InputDecoration(
                  hintText: getDeviceLocale() == "ar"
                      ? "كلمة المرور الجديدة : "
                      : "New Password : ",
                  hintStyle: TextStyle(
                      color: mode
                          ? Colors.white.withOpacity(.5)
                          : dayBar["blue2"].withOpacity(.5)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        width: .5,
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        width: .5,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        width: 1,
                      )),
                ),
              ),
            ),
            BlocBuilder<LunchLoadingCubit, LunchLoadingState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () async {
                    if (await checkConnection()) {
                      if (globalKey.currentState!.validate()) {
                        try {
                          context.read<LunchLoadingCubit>().lunchLoading(true);
                          var box = Hive.box(hiveBoxName);
                          if (box.get(isMainManager)) {
                            var data =
                                await supabase.from("main_manager").select();

                            if (data[0]["password"] == currentPassword) {
                              await supabase.auth.updateUser(
                                UserAttributes(password: newPassword),
                              );
                              await supabase
                                  .from("main_manager")
                                  .update({"password": newPassword}).eq(
                                      "password", currentPassword);
                            } else {
                              context
                                  .read<LunchLoadingCubit>()
                                  .lunchLoading(false);
                              lunchAwesomDialoge(
                                  DialogType.error,
                                  "e",
                                  getDeviceLocale() == "ar"
                                      ? "كلمة السر خاطئة"
                                      : "Incorrect password",
                                  context,
                                  getWidth(context),
                                  getHeight(context));
                            }
                          } else {
                            try {
                              var data = await supabase
                                  .from("current_user")
                                  .select()
                                  .eq("id", supabase.auth.currentUser!.id);

                              if (data[0]["password"] == currentPassword) {
                                await supabase.auth.updateUser(
                                  UserAttributes(password: newPassword),
                                );
                                await supabase
                                    .from("current_user")
                                    .update({"password": newPassword}).eq(
                                        "id", data[0]["id"]);
                              } else {
                                context
                                    .read<LunchLoadingCubit>()
                                    .lunchLoading(false);
                                lunchAwesomDialoge(
                                    DialogType.error,
                                    "e",
                                    getDeviceLocale() == "ar"
                                        ? "كلمة السر خاطئة"
                                        : "Incorrect password",
                                    context,
                                    getWidth(context),
                                    getHeight(context));
                              
                              }
                            } catch (e) {
                              print(e);
                            }
                          }

                          context.read<LunchLoadingCubit>().lunchLoading(false);
                          Navigator.pop(context);
                        } catch (e) {
                          context.read<LunchLoadingCubit>().lunchLoading(false);
                          lunchAwesomDialoge(
                              DialogType.error,
                              "e",
                              getDeviceLocale() == "ar"
                                  ? "يوجد خطأ ما"
                                  : "There is an error",
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
                              getDeviceLocale() == "ar" ? "تغيير" : "Change",
                              style: TextStyle(color: Colors.white),
                            )
                      : AutoSizeText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          minFontSize: 10,
                          maxFontSize: 15,
                          getDeviceLocale() == "ar" ? "تغيير" : "Change",
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
        ),
      )),
    );
  }
}
