import 'package:flutter/material.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/modules/translate_consts.dart';
import 'package:teach/features/login/presentation/log_in.dart';
import 'package:teach/features/welcom_screen/presentation/widgets/welcom.dart';

class PageVeiwScreen extends StatefulWidget {
  const PageVeiwScreen({super.key});

  @override
  State<PageVeiwScreen> createState() => _PageVeiwScreenState();
}

class _PageVeiwScreenState extends State<PageVeiwScreen> {
  late final PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = getWidth(context);
    var height = getHeight(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            width: width,
            height: height * .9,
            child: Stack(
              children: [
                PageView(
                  controller: pageController,
                  children: [
                    Welcom(
                      imagePath: const ["images/welcom4.png"],
                      description1: getDeviceLocale() == "ar"
                          ? Translation()
                              .translateMe["Arabic"]!["welcom_screen11"]
                          : Translation()
                              .translateMe["English"]!["welcom_screen11"],
                      description2: getDeviceLocale() == "ar"
                          ? Translation()
                              .translateMe["Arabic"]!["welcom_screen12"]
                          : Translation()
                              .translateMe["English"]!["welcom_screen12"],
                      onNext: () {
                        pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn);
                      },
                      check: 1,
                      onPrevius: () {},
                    ),
                    Welcom(
                      imagePath: const [
                        "images/student_meet.png",
                        "images/account.png"
                      ],
                      description1: getDeviceLocale() == "ar"
                          ? Translation()
                              .translateMe["Arabic"]!["welcom_screen21"]
                          : Translation()
                              .translateMe["English"]!["welcom_screen21"],
                      description2: "",
                      onNext: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LogIn(
                                
                              ),
                            ));
                      },
                      check: 2,
                      onPrevius: () {
                        pageController.animateToPage(pageController.initialPage,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
