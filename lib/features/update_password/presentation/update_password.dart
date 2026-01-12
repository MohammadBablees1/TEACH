import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/features/update_password/presentation/manager/update_password_loading/update_password_loading_cubit.dart';
import 'package:teach/features/update_password/presentation/widget/update_password_text_form_feild.dart';
import 'package:teach/features/update_password/repo/update_password_repo.dart';

// ignore: use_key_in_widget_constructors
class UpdatePassword extends StatefulWidget {
  late final TextEditingController currentPasswordController;
  late final TextEditingController newPasswordController;
  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  GlobalKey<FormState> globalKey = GlobalKey();
  @override
  void initState() {
    widget.currentPasswordController = TextEditingController();
    widget.newPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    widget.currentPasswordController.dispose();
    widget.newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
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
          icon: const Icon(
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
              child: UpdatePasswordTextFormFeild(
                  controller: widget.currentPasswordController,
                  hintText: getDeviceLocale() == "ar"
                      ? "كلمة المرور الحالية : "
                      : "Current Password : ",
                  validator: 1),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: UpdatePasswordTextFormFeild(
                  controller: widget.newPasswordController,
                  hintText: getDeviceLocale() == "ar"
                      ? "كلمة المرور الجديدة : "
                      : "New Password : ",
                  validator: 2),
            ),
            BlocBuilder<UpdatePasswordLoadingCubit, UpdatePasswordLoadingState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () async {
                    if (await checkConnection()) {
                      if (globalKey.currentState!.validate()) {
                        // ignore: use_build_context_synchronously
                        context.read<UpdatePasswordLoadingCubit>().start();

                        // ignore: use_build_context_synchronously
                        await UpdatePasswordRepo().update(context, widget);
                        // ignore: use_build_context_synchronously
                        context.read<UpdatePasswordLoadingCubit>().stope();
                      }
                    } else {
                      lunchAwesomDialoge(
                          DialogType.warning,
                          "e",
                          getDeviceLocale() == "ar"
                              ? "تأكد من اتصالك بالإنترنت"
                              : "Make sure you are connected to the Internet",
                          // ignore: use_build_context_synchronously
                          context,
                          // ignore: use_build_context_synchronously
                          getWidth(context),
                          // ignore: use_build_context_synchronously
                          getHeight(context));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      side: const BorderSide(
                    width: .5,
                  )),
                  child: state is UpdatePasswordLoading
                      ? state.loading
                          ? const SizedBox(
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
                              style: const TextStyle(color: Colors.white),
                            )
                      : AutoSizeText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          minFontSize: 10,
                          maxFontSize: 15,
                          getDeviceLocale() == "ar" ? "تغيير" : "Change",
                          style: const TextStyle(color: Colors.white),
                        ),
                );
              },
            ),
          ],
        ),
      )),
    );
  }
}