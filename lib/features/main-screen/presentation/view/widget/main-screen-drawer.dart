// ignore: file_names
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:teach/cubit/lunch_loading_cubit/lunch_loading_cubit.dart';
import 'package:teach/cubit/them_mode/them_mode_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/sql/sql.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/main.dart';
import 'package:teach/features/welcom_screen/presentation/page_veiw.dart';
import 'package:teach/features/about_app/presentation/about_app.dart';
import 'package:teach/screens/pages/code_generater.dart';
import 'package:teach/screens/pages/create_notification.dart';
import 'package:teach/features/sell_point/presentation/sell_point.dart';
import 'package:teach/features/user_profile/presentation/student_profile.dart';
import 'package:teach/features/recorded_code/presentation/recorded_code.dart';

class MainScreenDrawer extends StatefulWidget {
   // ignore: prefer_const_constructors_in_immutables
   MainScreenDrawer({super.key});

  @override
  State<MainScreenDrawer> createState() => _MainScreenDrawerState();
}

class _MainScreenDrawerState extends State<MainScreenDrawer> {
  var box = Hive.box(hiveBoxName);

  Future<void> _reauthenticateAndDelete() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      // Handle exceptions
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: getWidth(context),
        height: getHeight(context),
        decoration:
            BoxDecoration(color: mode ? const Color(0xFF121212) : Colors.white),
        child: ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    width: getWidth(context),
                    height: getWidth(context) * .4,
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: .5, color: Colors.grey))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: getWidth(context) * .2,
                          height: getWidth(context) * .2,
                          child: CircleAvatar(
                            backgroundColor:
                                const Color.fromARGB(255, 197, 197, 197),
                            child: Icon(
                              Icons.settings,
                              size: getWidth(context) * .1,
                              color:
                                  mode ? nightBar["orange"] : dayBar["blue3"],
                            ),
                          ),
                        ),
                        AutoSizeText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          minFontSize: 10,
                          maxFontSize: 15,
                          getDeviceLocale() == "ar" ? "الإعدادات" : "Settings",
                          style: TextStyle(
                              color: mode ? Colors.white : dayBar["blue3"],
                              fontSize: getWidth(context) * .05),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: getWidth(context),
                    height: getWidth(context) * 1.3,
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StudentProfile(),
                                ));
                          },
                          leading: Icon(
                            Icons.person,
                            color: mode ? Colors.white : dayBar["blue3"],
                          ),
                          title: AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            getDeviceLocale() == "ar"
                                ? "الملف الشخصي"
                                : "Profile",
                            style: TextStyle(
                                color: mode ? Colors.white : dayBar["blue3"]),
                          ),
                        ),
                        Container(
                          width: getWidth(context),
                          height: 1,
                          color: Colors.grey.shade300,
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SellPoint(),
                                ));
                          },
                          leading: Icon(
                            Icons.sell,
                            color: mode ? Colors.white : dayBar["blue3"],
                          ),
                          title: AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            getDeviceLocale() == "ar"
                                ? "نقاط البيع"
                                : "Points of Sale",
                            style: TextStyle(
                                color: mode ? Colors.white : dayBar["blue3"]),
                          ),
                        ),
                        Container(
                          width: getWidth(context),
                          height: 1,
                          color: Colors.grey.shade300,
                        ),
                        checkPermision(false, false, false, true, false, false)
                            ? Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RecordedCode(),
                                          ));
                                    },
                                    leading: Icon(
                                      Icons.code,
                                      color:
                                          mode ? Colors.white : dayBar["blue3"],
                                    ),
                                    title: AutoSizeText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      minFontSize: 10,
                                      maxFontSize: 15,
                                      getDeviceLocale() == "ar"
                                          ? "سجل الأكواد"
                                          : "Codes",
                                      style: TextStyle(
                                          color: mode
                                              ? Colors.white
                                              : dayBar["blue3"]),
                                    ),
                                  ),
                                  Container(
                                    width: getWidth(context),
                                    height: 1,
                                    color: Colors.grey.shade300,
                                  ),
                                ],
                              )
                            : Container(),
                        box.get(isMainManager)
                            ? ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CodeGenerater(),
                                      ));
                                },
                                leading: Icon(
                                  Icons.group_add_outlined,
                                  color: mode ? Colors.white : dayBar["blue3"],
                                ),
                                title: AutoSizeText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  minFontSize: 10,
                                  maxFontSize: 15,
                                  getDeviceLocale() == "ar"
                                      ? "إنشاء حساب مدير"
                                      : "create new manager",
                                  style: TextStyle(
                                      color: mode
                                          ? Colors.white
                                          : dayBar["blue3"]),
                                ),
                              )
                            : Container(),
                        box.get(isMainManager)
                            ? Container(
                                width: getWidth(context),
                                height: 1,
                                color: Colors.grey.shade300,
                              )
                            : Container(),
                        box.get(isMainManager) ||
                                checkPermision(
                                    false, false, false, false, false, true)
                            ? ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CreateNotification(),
                                      ));
                                },
                                leading: Icon(
                                  Icons.notification_add,
                                  color: mode ? Colors.white : dayBar["blue3"],
                                ),
                                title: AutoSizeText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  minFontSize: 10,
                                  maxFontSize: 15,
                                  getDeviceLocale() == "ar"
                                      ? "إنشاء إشعار جديد "
                                      : "create new notification",
                                  style: TextStyle(
                                      color: mode
                                          ? Colors.white
                                          : dayBar["blue3"]),
                                ),
                              )
                            : Container(),
                        box.get(isMainManager) ||
                                checkPermision(
                                    false, false, false, false, false, true)
                            ? Container(
                                width: getWidth(context),
                                height: 1,
                                color: Colors.grey.shade300,
                              )
                            : Container(),
                        SwitchListTile(
                          secondary: Icon(
                            Icons.nightlight,
                            color: mode ? Colors.white : dayBar["blue3"],
                          ),
                          value: mode,
                          activeColor: mode
                              ? Colors.green
                              : const Color.fromARGB(255, 11, 85, 145),
                          onChanged: (value) async {
                            mode = mode ? false : true;

                            BlocProvider.of<ThemModeCubit>(context)
                                .isDarkMode(mode);
                          },
                          title: AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            getDeviceLocale() == "ar"
                                ? "الوضع الليلي"
                                : "Night mode",
                            style: TextStyle(
                                color: mode ? Colors.white : dayBar["blue3"]),
                          ),
                        ),
                        Container(
                          width: getWidth(context),
                          height: 1,
                          color: Colors.grey.shade300,
                        ),
                        SwitchListTile(
                          secondary: Icon(
                            Icons.language,
                            color: mode ? Colors.white : dayBar["blue3"],
                          ),
                          value: getDeviceLocale() == "ar" ? false : true,
                          activeColor: mode
                              ? Colors.green
                              : const Color.fromARGB(255, 11, 85, 145),
                          onChanged: (value) async {
                            language = value;

                            BlocProvider.of<ThemModeCubit>(context)
                                .changeLanguage(language);

                            var data = await Sql().getLan();
                            if (data.isEmpty) {
                              await Sql().lunchEn();
                            } else {
                              await Sql().updateLan(
                                  // ignore: unrelated_type_equality_checks
                                  language == "ar" ? "false" : "true");
                            }
                          },
                          title: AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            getDeviceLocale() == "ar"
                                ? "اللغة الإنكليزية"
                                : "English language",
                            style: TextStyle(
                                color: mode ? Colors.white : dayBar["blue3"]),
                          ),
                        ),
                        Container(
                          width: getWidth(context),
                          height: 1,
                          color: Colors.grey.shade300,
                        ),
                        ListTile(
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AboutApp(),
                                ));
                          },
                          leading: Icon(
                            Icons.phone_android,
                            color: mode ? Colors.white : dayBar["blue3"],
                          ),
                          title: AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            getDeviceLocale() == "ar"
                                ? "حول التطبيق"
                                : "About the app",
                            style: TextStyle(
                                color: mode ? Colors.white : dayBar["blue3"]),
                          ),
                        ),
                        Container(
                          width: getWidth(context),
                          height: 1,
                          color: Colors.grey.shade300,
                        ),
                        ListTile(
                          onTap: () async {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor:
                                    mode ? nightBar["orange"] : dayBar["blue"],
                                content: SizedBox(
                                  width: getWidth(context) / 4,
                                  height: getHeight(context) / 8,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      AutoSizeText(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        minFontSize: 10,
                                        maxFontSize: 15,
                                        getDeviceLocale() == "ar"
                                            ? "هل أنت متأكد ؟"
                                            : "Are you sure?",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              if (await checkConnection()) {
                                                // ignore: use_build_context_synchronously
                                                context
                                                    .read<LunchLoadingCubit>()
                                                    .lunchLoading(true);

                                                await _reauthenticateAndDelete();
                                                // ignore: use_build_context_synchronously
                                                context
                                                    .read<LunchLoadingCubit>()
                                                    .lunchLoading(false);
                                                Navigator.pushAndRemoveUntil(
                                                    // ignore: use_build_context_synchronously
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const PageVeiwScreen(),
                                                    ),
                                                    (Route<dynamic> route) =>
                                                        false);
                                                var box = Hive.box(hiveBoxName);
                                                box.delete(isStudent);
                                                box.delete(isMainManager);
                                                box.delete(isManager);
                                                box.delete(isCode);
                                                box.delete(isFile);
                                                box.delete("info");
                                                mode = false;

                                                BlocProvider.of<ThemModeCubit>(
                                                    // ignore: use_build_context_synchronously
                                                    context).isDarkMode(mode);

                                                BlocProvider.of<ThemModeCubit>(
                                                    // ignore: use_build_context_synchronously
                                                    context).isDarkMode(false);
                                                BlocProvider.of<ThemModeCubit>(
                                                    // ignore: use_build_context_synchronously
                                                    context).changeLanguage(false);
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
                                            child: AutoSizeText(
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              minFontSize: 10,
                                              maxFontSize: 15,
                                              getDeviceLocale() == "ar"
                                                  ? "نعم"
                                                  : "Yes",
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: AutoSizeText(
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                minFontSize: 10,
                                                maxFontSize: 15,
                                                getDeviceLocale() == "ar"
                                                    ? "إلغاء"
                                                    : "Cancel",
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          leading: Icon(
                            Icons.output_sharp,
                            color: mode ? Colors.white : dayBar["blue3"],
                          ),
                          title: AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            getDeviceLocale() == "ar"
                                ? "تسجيل الخروج"
                                : "Sign out",
                            style: TextStyle(
                                color: mode ? Colors.white : dayBar["blue3"]),
                          ),
                        ),
                        Container(
                          width: getWidth(context),
                          height: 1,
                          color: Colors.grey.shade300,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
