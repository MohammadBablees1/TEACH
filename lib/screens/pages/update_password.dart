import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        title: Text(
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
                    // await supabase.auth.updateUser(
                    //   UserAttributes(password: newPassword),
                    // );
                    // if (await checkConnection()) {
                    //   if (globalKey.currentState!.validate()) {
                    //     try {
                    //       context.read<LunchLoadingCubit>().lunchLoading(true);
                    //       final user = FirebaseAuth.instance.currentUser;

                    //       // You'll need to get the user's current credentials (email/password)
                    //       // You might need to ask the user for their current password
                    //       final credential = EmailAuthProvider.credential(
                    //         email: user!.email!,
                    //         password:
                    //             currentPassword, // You need to obtain this from the user
                    //       );

                    //       // Re-authenticate the user
                    //       await user.reauthenticateWithCredential(credential);

                    //       // Now you can update the password
                    //       await user.updatePassword(newPassword);
                    //       context.read<LunchLoadingCubit>().lunchLoading(false);
                    //       Navigator.pop(context);
                    //     } catch (e) {
                    //       context.read<LunchLoadingCubit>().lunchLoading(false);
                    //       lunchAwesomDialoge(
                    //           DialogType.error,
                    //           "e",
                    //           getDeviceLocale() == "ar"
                    //               ? "يوجد خطأ ما"
                    //               : "There is an error",
                    //           context,
                    //           getWidth(context),
                    //           getHeight(context));
                    //     }
                    //   }
                    // } else {
                    //   lunchAwesomDialoge(
                    //       DialogType.warning,
                    //       "e",
                    //       getDeviceLocale() == "ar"
                    //           ? "تأكد من اتصالك بالإنترنت"
                    //           : "Make sure you are connected to the Internet",
                    //       context,
                    //       getWidth(context),
                    //       getHeight(context));
                    // }
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
                          : Text(
                              getDeviceLocale() == "ar" ? "تغيير" : "Change",
                              style: TextStyle(color: Colors.white),
                            )
                      : Text(
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
