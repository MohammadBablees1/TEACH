import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/features/user_profile/presentation/manager/student_profile_loading/student_profile_loading_cubit.dart';
import 'package:teach/features/user_profile/presentation/widget/student_profile_text_form_widget.dart';
import 'package:teach/features/user_profile/repo/edite_student_profile_repo.dart';
import 'package:teach/features/user_profile/repo/init_user_info.dart';
import 'package:teach/main.dart';
import 'package:teach/features/update_password/presentation/update_password.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class StudentProfile extends StatefulWidget {
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController universityNumberController;
  late final TextEditingController emailController;
  late final TextEditingController typeController;

  String currentUser = "";
  bool isEditing = false;
  bool emailEditing = false;

  StudentProfile({super.key});
  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  GlobalKey<FormState> globalKey = GlobalKey();
  @override
  initState() {
    widget.nameController = TextEditingController();
    widget.phoneController = TextEditingController();
    widget.universityNumberController = TextEditingController();
    widget.emailController = TextEditingController();
    widget.typeController = TextEditingController();
    super.initState();
    InitUserInfo().init(widget);
  }

  @override
  void dispose() {
    widget.nameController.dispose();
    widget.phoneController.dispose();
    widget.universityNumberController.dispose();
    widget.emailController.dispose();
    widget.typeController.dispose();
    super.dispose();
  }

  var box = Hive.box(hiveBoxName);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mode ? nightBar["orange"] : dayBar["blue3"],
      body: ListView(
        children: [
          Column(
            children: [
              SizedBox(
                  width: getWidth(context) * .3,
                  height: getWidth(context) * .4,
                  child: CircleAvatar(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          "images/icon.jpg",
                          width: getWidth(context),
                          fit: BoxFit.cover,
                        )),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: AlignmentDirectional.topStart,
                  child: Center(
                    child: AutoSizeText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 10,
                      maxFontSize: 15,
                      getDeviceLocale() == "ar"
                          ? "معلومات الحساب"
                          : "Account Information",
                      style: const TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: getHeight(context) - (getWidth(context) * .4),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: mode ? Colors.black : Colors.white),
            child: Form(
                key: globalKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StudentProfileTextFormWidget(
                        widget: widget,
                        hintText: getDeviceLocale() == "ar"
                            ? "اسم المستخدم : "
                            : "User name : ",
                        validator: 1,
                        controller: widget.nameController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StudentProfileTextFormWidget(
                        widget: widget,
                        hintText: getDeviceLocale() == "ar"
                            ? " رقم الهاتف : "
                            : " Phone number : ",
                        validator: 2,
                        controller: widget.phoneController,
                      ),
                    ),
                    !checkPermision(false, false, false, false, false, false)
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: StudentProfileTextFormWidget(
                              widget: widget,
                              hintText: getDeviceLocale() == "ar"
                                  ? " الرقم الجامعي  : "
                                  : " University number : ",
                              validator: 3,
                              controller: widget.universityNumberController,
                            ),
                          )
                        : const SizedBox.shrink(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StudentProfileTextFormWidget(
                        widget: widget,
                        hintText: getDeviceLocale() == "ar"
                            ? "البريد الإلكتروني: "
                            : "Email : ",
                        validator: 4,
                        controller: widget.emailController,
                      ),
                    ),
                    BlocBuilder<StudentProfileLoadingCubit,
                        StudentProfileLoadingState>(
                      builder: (context, state) {
                        var box = Hive.box(hiveBoxName);
                        if (box.get(isManager)) {
                          return Container();
                        }
                        return ElevatedButton(
                          onPressed: () async {
                            if (await checkConnection()) {
                              if (widget.isEditing &&
                                  globalKey.currentState!.validate()) {
                                // ignore: use_build_context_synchronously
                                context
                                    .read<StudentProfileLoadingCubit>()
                                    .start();
                                await EditeStudentProfileRepo()
                                    // ignore: use_build_context_synchronously
                                    .editeStudentProfile(context, widget);
                                // ignore: use_build_context_synchronously
                                context
                                    .read<StudentProfileLoadingCubit>()
                                    .stope();
                              } else {
                                // ignore: use_build_context_synchronously
                                context
                                    .read<StudentProfileLoadingCubit>()
                                    .stope();

                                lunchAwesomDialoge(
                                    DialogType.warning,
                                    "e",
                                    getDeviceLocale() == "ar"
                                        ? "لا يوجد تعديلات ليتم تعديلها"
                                        : "There are no modifications to be made.",
                                    // ignore: use_build_context_synchronously
                                    context,
                                    // ignore: use_build_context_synchronously
                                    getWidth(context),
                                    // ignore: use_build_context_synchronously
                                    getHeight(context));
                              }
                            } else {
                              // ignore: use_build_context_synchronously
                              context
                                  .read<StudentProfileLoadingCubit>()
                                  .stope();

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
                          child: state is StudentProfileLoading
                              ? state.loadng
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
                                      getDeviceLocale() == "ar"
                                          ? "تعديل"
                                          : "Edite Account",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )
                              : AutoSizeText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  minFontSize: 10,
                                  maxFontSize: 15,
                                  getDeviceLocale() == "ar"
                                      ? "تعديل"
                                      : "Edite Account",
                                  style: const TextStyle(color: Colors.white),
                                ),
                        );
                      },
                    ),
                    !checkPermision(false, false, false, false, false, false)
                        ? TextButton(
                            onPressed: () async {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UpdatePassword(),
                              ));
                            },
                            child: AutoSizeText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              minFontSize: 10,
                              maxFontSize: 15,
                              getDeviceLocale() == "ar"
                                  ? "تغيير كلمة السر"
                                  : "change password",
                              style: TextStyle(
                                  color: mode ? Colors.white : dayBar["blue2"]),
                            ))
                        : Container(),
                    TextButton(
                        onPressed: () async {
                          var tech = await supabase
                              .from("technical_support")
                              .select()
                              .eq("id", 1);
                          _openWhatsApp(tech[0]["phone"]);
                        },
                        child: AutoSizeText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          minFontSize: 10,
                          maxFontSize: 15,
                          getDeviceLocale() == "ar"
                              ? "الدعم الفني"
                              : "technical support",
                          style: TextStyle(
                              color: mode ? Colors.white : dayBar["blue2"]),
                        )),
                  ],
                )),
          )
        ],
      ),
    );
  }

  void _openWhatsApp(String phoneNumber) async {
    final url = 'https://wa.me/+963$phoneNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch WhatsApp';
    }
  }
}
