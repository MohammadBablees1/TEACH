import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach/cubit/password/password_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/modules/translate_consts.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/features/login/repo/login_repo.dart';
import 'package:teach/features/login/presentation/manager/login_confirm_password_visibility/login_confirm_password_visibility_cubit.dart';
import 'package:teach/features/login/presentation/manager/login_loading/login_loading_cubit.dart';
import 'package:teach/features/login/presentation/manager/login_password_visibility/login_password_visibility_cubit.dart';
import 'package:teach/features/login/presentation/widget/text_form_feild_login.dart';
// ignore: must_be_immutable
class LogIn extends StatefulWidget {
  late final TextEditingController codeController;
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController universityNumberController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  bool isVisible = false;
  bool confirmPasswordISVisible = false;
  LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  var isLoading = false;

  GlobalKey<FormState> globalKey = GlobalKey();
  @override
  void initState() {
    widget.nameController = TextEditingController();
    widget.phoneController = TextEditingController();
    widget.emailController = TextEditingController();
    widget.codeController = TextEditingController();
    widget.passwordController = TextEditingController();
    widget.confirmPasswordController = TextEditingController();
    widget.universityNumberController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    widget.codeController.dispose();
    widget.nameController.dispose();
    widget.phoneController.dispose();
    widget.emailController.dispose();
    widget.passwordController.dispose();
    super.dispose();
  }

  String? selectedValue;
  late Iterable<dynamic> id;
  Object? selectedCollage;
  String? previusGrade;
  String? previusCollage;
  String? selectedGrade;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
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
            icon: const Icon(Icons.arrow_back_ios)),
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
                Image.asset("images/log_in.png"),
                TextFormFeildLogIn(
                  controller: widget.nameController,
                  hintText: getDeviceLocale() == "ar"
                      ? "اكتب الاسم الكامل هنا ..."
                      : "Write full name here...",
                  prefixIcon: Icon(
                    Icons.person,
                    color: dayBar["blue2"],
                  ),
                  validator: 1,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                ),
                TextFormFeildLogIn(
                    obscureText: false,
                    controller: widget.phoneController,
                    hintText: getDeviceLocale() == "ar"
                        ? Translation().translateMe["Arabic"]!["phone"]
                        : Translation().translateMe["English"]!["phone"],
                    prefixIcon: Icon(
                      Icons.phone,
                      color: dayBar["blue2"],
                      applyTextScaling: false,
                    ),
                    validator: 2,
                    keyboardType: TextInputType.phone),
                TextFormFeildLogIn(
                    controller: widget.universityNumberController,
                    hintText: getDeviceLocale() == "ar"
                        ? "اكتب رقمك الجامعي هنا..."
                        : "Write your university number here...",
                    prefixIcon: Icon(
                      Icons.numbers,
                      color: dayBar["blue2"],
                    ),
                    obscureText: false,
                    validator: 3,
                    keyboardType: TextInputType.number),
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
                                            value: value,
                                            child: AutoSizeText(
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                minFontSize: 10,
                                                maxFontSize: 15,
                                                value),
                                          ))
                                      .toList()
                                  : (data)!
                                      .map((String value) => DropdownMenuItem(
                                            value: value,
                                            child: AutoSizeText(
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                minFontSize: 10,
                                                maxFontSize: 15,
                                                value),
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
                                    const BorderRadius.all(Radius.circular(20)),
                              )),
                            ),
                          ),
                        );
                      }
                    }),
                TextFormFeildLogIn(
                    obscureText: false,
                    controller: widget.emailController,
                    hintText: getDeviceLocale() == "ar"
                        ? Translation().translateMe["Arabic"]!["email"]
                        : Translation().translateMe["English"]!["email"],
                    prefixIcon: Icon(
                      Icons.email,
                      color: dayBar["blue2"],
                    ),
                    validator: 4,
                    keyboardType: TextInputType.emailAddress),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<LoginPasswordVisibilityCubit,
                      LoginPasswordVisibilityState>(
                    builder: (context, state) {
                      return TextFormFeildLogIn(
                          obscureText: !(state is LoginPasswordVisibility &&
                              state.isVisible),
                          controller: widget.passwordController,
                          hintText: getDeviceLocale() == "ar"
                              ? Translation().translateMe["Arabic"]!["password"]
                              : Translation()
                                  .translateMe["English"]!["password"],
                          prefixIcon: IconButton(
                            onPressed: () {
                              context
                                  .read<LoginPasswordVisibilityCubit>()
                                  .changeVisibility(!widget.isVisible);
                              widget.isVisible = !widget.isVisible;
                            },
                            icon: Icon(
                              state is LoginPasswordVisibility &&
                                      state.isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: dayBar["blue2"],
                            ),
                          ),
                          validator: 5,
                          keyboardType: TextInputType.emailAddress);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<LoginConfirmPasswordVisibilityCubit,
                      LoginConfirmPasswordVisibilityState>(
                    builder: (context, state) {
                      return TextFormFeildLogIn(
                          obscureText:
                              !(state is LoginConfirmPasswordVisibility &&
                                  state.isVisible),
                          controller: widget.confirmPasswordController,
                          hintText: getDeviceLocale() == "ar"
                              ? "تأكيد كلمة السر..."
                              : "Confirm password...",
                          prefixIcon: IconButton(
                            onPressed: () {
                              context
                                  .read<LoginConfirmPasswordVisibilityCubit>()
                                  .changeVisibility(
                                      !widget.confirmPasswordISVisible);
                              widget.confirmPasswordISVisible =
                                  !widget.confirmPasswordISVisible;
                            },
                            icon: Icon(
                              state is LoginConfirmPasswordVisibility &&
                                      state.isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: dayBar["blue2"],
                            ),
                          ),
                          validator: 6,
                          keyboardType: TextInputType.emailAddress);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: BlocBuilder<LoginLoadingCubit, LoginLoadingState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () async {
                          if (globalKey.currentState!.validate()) {
                            if (selectedGrade != null) {
                              await LoginRepo().createNewUser(
                                  context,
                                  widget.nameController.text.trim(),
                                  widget.emailController.text.trim(),
                                  widget.phoneController.text.trim(),
                                  widget.universityNumberController.text.trim(),
                                  selectedGrade,
                                  widget.passwordController.text.trim());
                            } else {
                              context.read<LoginLoadingCubit>().stope();
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
                          child: state is LoginLoading && state.loading
                              ? const Center(
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
                                  style: const TextStyle(color: Colors.white),
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
}
