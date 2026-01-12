import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach/cubit/them_mode/them_mode_cubit.dart';
import 'package:teach/features/main-screen/presentation/view/manager/managerScreen/manager_screen_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/features/main-screen/repo/main_screen_fcm_token.dart';
import 'package:teach/features/main-screen/presentation/view/widget/main-screen-bottom-navigation-bar.dart'
    show mainScreenBottomNavigationBar;
import 'package:teach/features/main-screen/presentation/view/widget/main-screen-drawer.dart';
import 'package:teach/features/main-screen/presentation/view/widget/main_screen_body.dart';
import 'package:teach/features/main-screen/presentation/view/widget/add_ads.dart';
import 'package:teach/features/main-screen/presentation/view/widget/add_folder.dart';
import 'package:teach/features/main-screen/presentation/view/widget/add_phone_number.dart';

// ignore: must_be_immutable
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    MainScreenFcmToken().registerFCMToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemModeCubit, ThemModeState>(
      builder: (context, state) {
        final isDark = state is ChangeLanguage ? state.isDark : mode;
        return Scaffold(
           
            extendBody: true,
            extendBodyBehindAppBar: true,
            body: BlocBuilder<ManagerScreenCubit, ManagerScreenState>(
              builder: (context, state) {
                if (state is Indexed && state.currentIndex == 0) {
                  return MainScreenBody();
                } else if (state is Indexed && state.currentIndex == 1) {
                  return AddFolder();
                } else if (state is Indexed && state.currentIndex == 2) {
                  return AddAds();
                } else if (state is Indexed && state.currentIndex == 3) {
                  return const AddPhoneNumber();
                }
                return MainScreenBody();
              },
            ),
            bottomNavigationBar:
                checkPermision(false, false, false, false, true, false)
                    ? const mainScreenBottomNavigationBar()
                    : Container(),
            drawer:  MainScreenDrawer());
      },
    );
  }
}
