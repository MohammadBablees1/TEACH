import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teach/cubit/lunch_loading_cubit/lunch_loading_cubit.dart';
import 'package:teach/cubit/password/password_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/modules/translate_consts.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/main.dart';
import 'package:teach/features/student-main-screen/presentation/student_main_screen.dart';
import 'package:teach/screens/pages/update_password_screen.dart';

class UpdateUserPassword extends StatefulWidget {
  var passwordController = TextEditingController();
  var isVisible = false;

  @override
  State<UpdateUserPassword> createState() => _UpdateUserPasswordState();
}

class _UpdateUserPasswordState extends State<UpdateUserPassword> {
  var userPassword = "";
  GlobalKey<FormState> globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Form(
        key: globalKey,
        child: Column(
          children: [
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
                          ? "اكتب كلمة السر الجديدة هنا..."
                          : "Type the new password here...",
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
            BlocBuilder<LunchLoadingCubit, LunchLoadingState>(
              builder: (context, state) {
                return ElevatedButton(
                    onPressed: () async {
                      if (globalKey.currentState!.validate()) {
                        try {
                          context.read<LunchLoadingCubit>().lunchLoading(true);
                          await supabase.auth.updateUser(
                              UserAttributes(password: userPassword.trim()));
                          await supabase
                              .from("current_user")
                              .update({"password": userPassword}).eq(
                                  "id", await supabase.auth.currentUser!.id);
                          var box = Hive.box(hiveBoxName);
                          box.put(isMainManager, false);
                          box.put(isManager, false);
                          box.put(isStudent, true);
                          context.read<LunchLoadingCubit>().lunchLoading(false);
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => StudentMainScreen(),
                              ),
                              (Route<dynamic> route) => false);
                        } catch (e) {
                          context.read<LunchLoadingCubit>().lunchLoading(false);
                          print(e);
                          lunchAwesomDialoge(
                              DialogType.error,
                              "e",
                              getDeviceLocale() == "ar"
                                  ? "حدث خطأ ما!"
                                  : "Something went wrong!",
                              context,
                              getWidth(context),
                              getHeight(context));
                        }
                      }
                    },
                    child: state is LunchLoading && state.loading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            getDeviceLocale() == "ar"
                                ? Translation().translateMe["Arabic"]!["Log_in"]
                                : Translation()
                                    .translateMe["English"]!["Log_in"],
                            style: TextStyle(color: Colors.white),
                          ));
              },
            )
          ],
        ),
      ),
    );
  }
}
