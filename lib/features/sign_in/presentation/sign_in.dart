import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach/cubit/changeOpacity/change_opacity_cubit.dart';
import 'package:teach/cubit/change_code/code_changed_cubit.dart';
import 'package:teach/cubit/password/password_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/modules/translate_consts.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/features/bar_code_scanner/presentation/manager/catch_code_for_sign_in/catch_code_for_sign_in_cubit.dart';
import 'package:teach/features/sign_in/presentation/manager/sign_in_loading/sign_in_loading_cubit.dart';
import 'package:teach/features/sign_in/presentation/widget/text_form_feild_sign_in.dart';
import 'package:teach/features/bar_code_scanner/presentation/bar_code_scanner.dart';
import 'package:teach/screens/pages/reset_password.dart';

// ignore: must_be_immutable
class SignUp extends StatefulWidget {
  var isVisible = false;
  var userCode = "";
  var isCodeEnter = false;
  late final TextEditingController codeController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController universityNumberController;

  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  void initState() {
    widget.codeController = TextEditingController();
    widget.emailController = TextEditingController();
    widget.passwordController = TextEditingController();
    widget.universityNumberController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    widget.codeController.dispose();
    widget.emailController.dispose();
    widget.passwordController.dispose();
    widget.universityNumberController.dispose();
    super.dispose();
  }

  var userEmail = "", userPassword = "";
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
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
        leading: IconButton(
            onPressed: () {
              context.read<PasswordCubit>().changePasswordVisibility(false);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: PopScope(
        canPop: true,
        child: SafeArea(
            child: SingleChildScrollView(
          child: Form(
            key: globalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset("images/log_in.png"),
                TextFormFeildSignIn(
                  controller: widget.emailController,
                  hintText: getDeviceLocale() == "ar"
                      ? "اكتب البريد الإلكتروني هنا..."
                      : "Type your email here...",
                  prefixIcon: const Icon(Icons.email),
                  validator: 1,
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFormFeildSignIn(
                  controller: widget.universityNumberController,
                  hintText: getDeviceLocale() == "ar"
                      ? "اكتب رقمك الجامعي هنا..."
                      : "Write your university number here...",
                  prefixIcon: const Icon(Icons.numbers),
                  validator: 2,
                  keyboardType: TextInputType.number,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<PasswordCubit, PasswordState>(
                    builder: (context, state) {
                      return TextFormFeildSignIn(
                        controller: widget.passwordController,
                        hintText: getDeviceLocale() == "ar"
                            ? Translation().translateMe["Arabic"]!["password"]
                            : Translation().translateMe["English"]!["password"],
                        prefixIcon: const Icon(Icons.password),
                        validator: 3,
                        keyboardType: TextInputType.visiblePassword,
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
                            title: AutoSizeText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                minFontSize: 10,
                                maxFontSize: 15,
                                getDeviceLocale() == "ar"
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: state is ChangeOpacity && state.opacity > 0
                                ? BlocBuilder<CodeChangedCubit,
                                    CodeChangedState>(
                                    builder: (context, state) {
                                      if (state is ChangeCode) {
                                        return BlocBuilder<
                                            CatchCodeForSignInCubit,
                                            CatchCodeForSignInState>(
                                          builder: (context, cachedCode) {
                                            if (cachedCode
                                                is CatchCodeForSignIn) {
                                              widget.codeController.text =
                                                  cachedCode.code;
                                            }
                                            return TextFormFeildSignIn(
                                              controller: widget.codeController,
                                              hintText: getDeviceLocale() ==
                                                      "ar"
                                                  ? Translation().translateMe[
                                                      "Arabic"]!["code_r"]
                                                  : Translation().translateMe[
                                                      "English"]!["code_r"],
                                              prefixIcon: Icon(
                                                Icons.code,
                                                color: dayBar["blue2"],
                                              ),
                                              validator: 4,
                                              keyboardType: TextInputType.text,
                                            );
                                          },
                                        );
                                      } else {
                                        return Column(
                                          children: [
                                            BlocBuilder<CatchCodeForSignInCubit,
                                                CatchCodeForSignInState>(
                                              builder: (context, cachedCode) {
                                                if (cachedCode
                                                    is CatchCodeForSignIn) {
                                                  widget.codeController.text =
                                                      cachedCode.code;
                                                }
                                                return TextFormFeildSignIn(
                                                  controller:
                                                      widget.codeController,
                                                  hintText: getDeviceLocale() ==
                                                          "ar"
                                                      ? Translation()
                                                              .translateMe[
                                                          "Arabic"]!["code_r"]
                                                      : Translation()
                                                              .translateMe[
                                                          "English"]!["code_r"],
                                                  prefixIcon: Icon(
                                                    Icons.code,
                                                    color: dayBar["blue2"],
                                                  ),
                                                  validator: 4,
                                                  keyboardType:
                                                      TextInputType.text,
                                                );
                                              },
                                            ),
                                            ElevatedButton(
                                                onPressed: () async {
                                                  await Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        BarCodeScanner(
                                                      check: true,
                                                    ),
                                                  ));
                                                  // widget.codeController.text =
                                                  //     code;

                                                  // ignore: use_build_context_synchronously
                                                  // context
                                                  //     .read<CodeChangedCubit>()
                                                  //     .changeCode(code);
                                                },
                                                child: AutoSizeText(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  minFontSize: 10,
                                                  maxFontSize: 15,
                                                  getDeviceLocale() == "ar"
                                                      ? "أو امسح الكود من هنا"
                                                      : "Or scan the code here",
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ))
                                          ],
                                        );
                                      }
                                    },
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResetPassword(),
                          ));
                    },
                    child: AutoSizeText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 10,
                      maxFontSize: 15,
                      getDeviceLocale() == "ar"
                          ? "نسيت كلمة السر"
                          : "Forgot your password",
                      style: TextStyle(color: dayBar["blue2"]),
                    )),
                BlocBuilder<SignInLoadingCubit, SignInLoadingState>(
                  builder: (context, state) {
                    return ElevatedButton(
                        onPressed: () async {
                          if (globalKey.currentState!.validate()) {
                            if (widget.codeController.text.isEmpty) {
                              try {
                                await context
                                    .read<SignInLoadingCubit>()
                                    .loading(
                                        widget.emailController.text.trim(),
                                        widget.passwordController.text.trim(),
                                        widget.universityNumberController.text
                                            .trim(),
                                        context);
                                // ignore: use_build_context_synchronously
                                context.read<SignInLoadingCubit>().stop();
                              } catch (error) {
                                // ignore: use_build_context_synchronously
                                context.read<SignInLoadingCubit>().stop();
                                
                                lunchAwesomDialoge(
                                    DialogType.error,
                                    "e",
                                    error.toString(),
                                    // ignore: use_build_context_synchronously
                                    context,
                                    // ignore: use_build_context_synchronously
                                    getWidth(context),
                                    // ignore: use_build_context_synchronously
                                    getHeight(context));
                              }
                            } else {
                              try {
                                await context
                                    .read<SignInLoadingCubit>()
                                    .managerLoading(
                                        widget.emailController.text.trim(),
                                        widget.passwordController.text.trim(),
                                        widget.universityNumberController.text
                                            .trim(),
                                        context,
                                        widget.codeController.text.trim());
                                // ignore: use_build_context_synchronously
                                context.read<SignInLoadingCubit>().stop();
                              } catch (e) {
                                // ignore: use_build_context_synchronously
                                context.read<SignInLoadingCubit>().stop();
                                lunchAwesomDialoge(
                                    DialogType.error,
                                    "e",
                                    e.toString(),
                                    // ignore: use_build_context_synchronously
                                    context,
                                    // ignore: use_build_context_synchronously
                                    getWidth(context),
                                    // ignore: use_build_context_synchronously
                                    getHeight(context));
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(),
                        child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: state is SignInLoading && state.loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : AutoSizeText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    minFontSize: 10,
                                    maxFontSize: 15,
                                    getDeviceLocale() == "ar"
                                        ? Translation()
                                            .translateMe["Arabic"]!["Log_in"]
                                        : Translation()
                                            .translateMe["English"]!["Log_in"],
                                    style: const TextStyle(color: Colors.white),
                                  )));
                  },
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}
