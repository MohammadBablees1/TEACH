import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';
import 'package:teach/cubit/loading_pdf/loading_pdf_cubit.dart';
import 'package:teach/cubit/lunch_loading_cubit/lunch_loading_cubit.dart';
import 'package:teach/cubit/password/password_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/modules/translate_consts.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/main.dart';
import 'package:teach/screens/pages/update_user_password.dart';

class ResetPassword extends StatefulWidget {
  var emailController = TextEditingController();
  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  var userEmail = "";
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BlocBuilder<LoadingPdfCubit, LoadingPdfState>(
                    builder: (context, state) {
                      return ElevatedButton(
                          onPressed: () async {
                            if (globalKey.currentState!.validate()) {
                              context.read<LoadingPdfCubit>().loadingPdf(true);
                              var data = await supabase
                                  .from("current_user")
                                  .select()
                                  .eq("email", userEmail)
                                  .maybeSingle();
                              if (data == null) {
                                context
                                    .read<LoadingPdfCubit>()
                                    .loadingPdf(false);
                                lunchAwesomDialoge(
                                    DialogType.error,
                                    "e",
                                    getDeviceLocale() == "ar"
                                        ? "هذا الحساب غير متوفّر!"
                                        : "This account is not available!",
                                    context,
                                    getWidth(context),
                                    getHeight(context));
                              } else {
                                final _mobileDeviceIdentifier =
                                    await MobileDeviceIdentifier()
                                        .getDeviceId();
                                if (data["deviceId"] ==
                                        _mobileDeviceIdentifier ||
                                    data["deviceId"].toString().isEmpty) {
                                  context
                                      .read<LoadingPdfCubit>()
                                      .loadingPdf(false);
                                  supabase.auth.signInWithPassword(
                                      email: data["email"],
                                      password: data["password"]);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UpdateUserPassword(),
                                      ));
                                } else {
                                  context
                                      .read<LoadingPdfCubit>()
                                      .loadingPdf(false);
                                  lunchAwesomDialoge(
                                      DialogType.error,
                                      "e",
                                      getDeviceLocale() == "ar"
                                          ? "برجى التواصل مع الدعم الفني"
                                          : "Please contact technical support",
                                      context,
                                      getWidth(context),
                                      getHeight(context));
                                }
                              }
                            }
                          },
                          child: state is LoadingPdf && state.loading
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : AutoSizeText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  minFontSize: 10,
                                  maxFontSize: 15,
                                  getDeviceLocale() == "ar"
                                      ? "تحقق من حسابي"
                                      : "Check my account",
                                  style: TextStyle(color: Colors.white),
                                ));
                    },
                  ),
                  BlocBuilder<LunchLoadingCubit, LunchLoadingState>(
                    builder: (context, state) {
                      return ElevatedButton(
                          onPressed: () async {
                            context
                                .read<LunchLoadingCubit>()
                                .lunchLoading(true);
                            var data = await supabase
                                .from("technical_support")
                                .select();

                            context
                                .read<LunchLoadingCubit>()
                                .lunchLoading(false);
                            lunchAwesomDialoge(
                                DialogType.info,
                                "e",
                                " ${data[0]["name"]} : ${data[0]["phone"]}",
                                context,
                                getWidth(context),
                                getHeight(context));
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
                                      ? "الدعم الفني"
                                      : "technical support",
                                  style: TextStyle(color: Colors.white),
                                ));
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  checkDeviceId() async {}
}
