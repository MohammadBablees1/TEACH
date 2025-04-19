import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/modules/translate_consts.dart';
import 'package:teach/screens/pages/log_in.dart';
import 'package:teach/screens/pages/welcom.dart';

class PageVeiwScreen extends StatelessWidget {
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    var width = getWidth(context);
    var height = getHeight(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: width,
            height: height,
            child: Stack(
              children: [
                PageView(
                  controller: pageController,
                  children: [
                    Welcom(
                      imagePath: ["images/welcom4.png"],
                      // imagePath: [
                      //   "https://i.giphy.com/media/v1.Y2lkPTc5MGI3NjExNDE3YjB5dGd6d21qczB1NXB1b28yYnhnbXQ4eXU4ZWdzam1janYzaiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/bcKmIWkUMCjVm/giphy.gif"
                      // ],
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
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn);
                      },
                      check: 1,
                      onPrevius: () {},
                    ),
                    Welcom(
                      imagePath: [
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
                                userName1: "",
                                userPhone1: "",
                                userEmail1: "",
                                userPassword1: "",
                                userCode1: "",
                              ),
                            ));
                      },
                      check: 2,
                      onPrevius: () {
                        pageController.animateToPage(pageController.initialPage,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      },
                    ),
                  ],
                ),
                // Center(
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                //     children: [
                //       Container(
                //         height: height / 3,
                //       ),
                //       SmoothPageIndicator(
                //         controller: pageController, // PageController
                //         count: 2,

                //         effect: WormEffect(
                //             activeDotColor:
                //                 Colors.orange), // your preferred effect
                //         onDotClicked: (index) {},
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
