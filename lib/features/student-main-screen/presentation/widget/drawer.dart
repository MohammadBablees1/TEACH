import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:teach/features/student-main-screen/presentation/widget/student_main_screen_drawer_list_tile.dart';
import 'package:teach/features/user_profile/presentation/manager/change_name/change_name_cubit.dart';
import 'package:teach/cubit/them_mode/them_mode_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/sql/sql.dart';
import 'package:teach/features/bar_code_scanner/presentation/bar_code_scanner.dart';
import 'package:teach/features/student-main-screen/presentation/widget/logout.dart';
import 'package:teach/features/student-main-screen/presentation/widget/manual_code.dart';
import 'package:teach/features/about_app/presentation/about_app.dart';
import 'package:teach/features/sell_point/presentation/sell_point.dart';
import 'package:teach/features/student_manage_code/presentation/student_manage_codes.dart';
import 'package:teach/features/user_profile/presentation/student_profile.dart';

class DrawerStudentMainScreen extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  DrawerStudentMainScreen({super.key});
  @override
  State<DrawerStudentMainScreen> createState() =>
      _DrawerStudentMainScreenState();
}

class _DrawerStudentMainScreenState extends State<DrawerStudentMainScreen> {
  var box = Hive.box(hiveBoxName);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: getWidth(context),
        height: getHeight(context),
        decoration:
            BoxDecoration(color: mode ? const Color(0xFF121212) : Colors.white),
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  SizedBox(
                      width: getWidth(context) * .2,
                      height: getWidth(context) * .2,
                      child: CircleAvatar(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              "images/icon.jpg",
                              width: getWidth(context),
                              fit: BoxFit.cover,
                            )),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  BlocBuilder<ChangeNameCubit, ChangeNameState>(
                    builder: (context, state) {
                      return AutoSizeText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 10,
                        maxFontSize: 15,
                        box.get("student_name") ?? "غير معرّف",
                        style: TextStyle(
                          color: mode ? Colors.white : dayBar["blue3"],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            StudentMainScreenDrawerListTile(
              icon: Icons.person,
              title: getDeviceLocale() == "ar" ? "الملف الشخصي" : "Profile",
              onTab: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentProfile(),
                    ));
              },
            ),
            StudentMainScreenDrawerListTile(
              icon: Icons.precision_manufacturing_rounded,
              title: getDeviceLocale() == "ar"
                  ? "إدارة الاشتراكات"
                  : "Subscription Management",
              onTab: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StudentManageCodes(),
                    ));
              },
            ),
            StudentMainScreenDrawerListTile(
              icon: Icons.sell,
              title:
                  getDeviceLocale() == "ar" ? "نقاط البيع" : "Points of Sale",
              onTab: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SellPoint(),
                    ));
              },
            ),
            StudentMainScreenDrawerListTile(
              icon: Icons.money,
              title: getDeviceLocale() == "ar"
                  ? "تفعيل اشتراك تلقائي"
                  : "Activate automatic subscription",
              onTab: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BarCodeScanner(
                        check: false,
                      ),
                    ));
              },
            ),
            StudentMainScreenDrawerListTile(
              icon: Icons.money,
              title: getDeviceLocale() == "ar"
                  ? "تفعيل اشتراك يدوي"
                  : "Manual subscription activation",
              onTab: () {
                showDialog(
                  context: context,
                  builder: (context) => ManualCode(),
                );
              },
            ),

            SwitchListTile(
              value: mode,
              secondary: Icon(
                Icons.nightlight,
                color: mode ? Colors.white : dayBar["blue3"],
              ),
              activeColor:
                  mode ? Colors.green : const Color.fromARGB(255, 11, 85, 145),
              onChanged: (value) async {
                mode = mode ? false : true;

                BlocProvider.of<ThemModeCubit>(context).isDarkMode(mode);
              },
              title: AutoSizeText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                minFontSize: 10,
                maxFontSize: 15,
                getDeviceLocale() == "ar" ? "الوضع الليلي" : "Night mode",
                style: TextStyle(color: mode ? Colors.white : dayBar["blue3"]),
              ),
            ),

            Container(
              width: getWidth(context),
              height: 1,
              color: mode ? Colors.grey.shade300 : dayBar["blue3"],
            ),
            SwitchListTile(
              secondary: Icon(
                Icons.language,
                color: mode ? Colors.white : dayBar["blue3"],
              ),
              value: getDeviceLocale() == "ar" ? false : true,
              activeColor:
                  mode ? Colors.green : const Color.fromARGB(255, 11, 85, 145),
              onChanged: (value) async {
                language = value;

                BlocProvider.of<ThemModeCubit>(context)
                    .changeLanguage(language);

                var data = await Sql().getLan();
                if (data.isEmpty) {
                  await Sql().lunchEn();
                } else {
                  
                  // ignore: unrelated_type_equality_checks
                  await Sql().updateLan(language == "ar" ? "false" : "true");
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
                    color: mode ? Colors.grey.shade300 : dayBar["blue3"]),
              ),
            ),
            Container(
              width: getWidth(context),
              height: 1,
              color: mode ? Colors.grey.shade300 : dayBar["blue3"],
            ),
            StudentMainScreenDrawerListTile(
              icon: Icons.phone_android,
              title:
                  getDeviceLocale() == "ar" ? "حول التطبيق" : "About the app",
              onTab: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutApp(),
                    ));
              },
            ),
            StudentMainScreenDrawerListTile(
              icon: Icons.output_sharp,
              title: getDeviceLocale() == "ar" ? "تسجيل الخروج" : "Sign out",
              onTab: () {
                showDialog(
                  context: context,
                  builder: (context) => const Logout(),
                );
              },
            ),

         
          ],
        ),
      ),
    );
  }
}
