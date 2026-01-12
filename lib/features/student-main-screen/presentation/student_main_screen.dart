import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:teach/cubit/them_mode/them_mode_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/features/main-screen/repo/main_screen_fcm_token.dart';
import 'package:teach/features/student-main-screen/presentation/widget/bodyStudentMAinScreen.dart';
import 'package:teach/features/student-main-screen/presentation/widget/drawer.dart';
import 'package:teach/features/student-main-screen/repo/request_notification.dart';

class StudentMainScreen extends StatefulWidget {
  const StudentMainScreen({super.key});
  @override
  State<StudentMainScreen> createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends State<StudentMainScreen> {
  bool _askedOnce = false;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_askedOnce) {
      _askedOnce = true;
      RequestNotification().requestNotificationPermission();
    }
  }

  @override
  void initState() {
    MainScreenFcmToken().registerFCMToken();
    super.initState();
  }

  var box = Hive.box(hiveBoxName);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemModeCubit, ThemModeState>(
      builder: (context, state) {
        final isDark = state is ChangeLanguage ? state.isDark : mode;
        return Scaffold(
          drawer:  DrawerStudentMainScreen(),
          body: Bodystudentmainscreen(),
        );
      },
    );
  }
}