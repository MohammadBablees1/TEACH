import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/modules/translate_consts.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/screens/pages/sign_in.dart';

// ignore: must_be_immutable
class Welcom extends StatefulWidget {
  List imagePath;
  var check = 1;

  String description1;
  String description2;
  VoidCallback onNext;
  VoidCallback onPrevius;

  Welcom({
    required this.imagePath,
    required this.description1,
    required this.description2,
    required this.onNext,
    required this.onPrevius,
    required this.check,
  });

  @override
  State<Welcom> createState() => _WelcomState();
}

class _WelcomState extends State<Welcom> {
  var selectedAcount = 6;

  var userName = "";

  @override
  Widget build(BuildContext context) {
    if (widget.check == 1) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(widget.imagePath[0]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutoSizeText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              minFontSize: 10,
              maxFontSize: 15,
              widget.description1,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutoSizeText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              minFontSize: 10,
              maxFontSize: 15,
              widget.description2,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(),
                  onPressed: widget.onNext,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: AutoSizeText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 10,
                      maxFontSize: 15,
                      getDeviceLocale() == "ar"
                          ? Translation().translateMe["Arabic"]!["next_button"]
                          : Translation()
                              .translateMe["English"]!["next_button"],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else if (widget.check == 2) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            height: getWidth(context) / 3,
            child: Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset("images/white_icon.jpg")),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                setState(() {
                  selectedAcount = 5;
                  selectedPublicAcount = selectedAcount;
                });
              },
              child: AnimatedContainer(
                width: getWidth(context),
                duration: Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1,
                      color: selectedAcount == 5
                          ? Colors.orange
                          : dayBar["blue2"]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        width: getWidth(context) * .35,
                        height: getWidth(context) * .35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          child: Image.asset(
                            widget.imagePath[1],
                          ),
                        )),
                    Container(
                      height: getWidth(context) * .2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            widget.description1.split(",").first,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            getDeviceLocale() == "ar"
                                ? "إذا كان لديك حساب بالفعل "
                                : "If you already have an account ",
                          ),
                          AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            getDeviceLocale() == "ar"
                                ? "يمكنك الدخول إليه من هنا"
                                : "you can access it from here",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                setState(() {
                  selectedAcount = 0;
                  selectedPublicAcount = selectedAcount;
                });
              },
              child: AnimatedContainer(
                width: getWidth(context),
                duration: Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1,
                      color: selectedAcount == 0
                          ? Colors.orange
                          : dayBar["blue2"]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        width: getWidth(context) * .35,
                        height: getWidth(context) * .35,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          child: Image.asset(
                            widget.imagePath[0],
                          ),
                        )),
                    SizedBox(
                      height: getWidth(context) * .2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            widget.description1.split(",")[1],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            getDeviceLocale() == "ar"
                                ? "إذا كنت طالباً جديداً "
                                : "If you are a new student",
                          ),
                          AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            getDeviceLocale() == "ar"
                                ? "يمكنك تسجيل الدخول من هنا"
                                : "You can log in from here.",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(),
                  onPressed: selectedAcount < 5
                      ? widget.onNext
                      : selectedAcount == 5
                          ? () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUp(
                                      codeController:
                                          TextEditingController(text: ""),
                                      emailController:
                                          TextEditingController(text: ""),
                                      passwordController:
                                          TextEditingController(text: ""),
                                      universityNumberController:
                                          TextEditingController(text: ""),
                                    ),
                                  ));
                            }
                          : () {
                              lunchAwesomDialoge(
                                  DialogType.warning,
                                  "error",
                                  getDeviceLocale() == "ar"
                                      ? Translation().translateMe["Arabic"]![
                                          "choose_acount"]
                                      : Translation().translateMe["English"]![
                                          "choose_acount"],
                                  context,
                                  getWidth(context),
                                  getHeight(context));
                            },
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: AutoSizeText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 10,
                      maxFontSize: 15,
                      getDeviceLocale() == "ar"
                          ? Translation().translateMe["Arabic"]!["Log_in"]
                          : Translation().translateMe["English"]!["Log_in"],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
