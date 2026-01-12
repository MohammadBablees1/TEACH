import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/modules/translate_consts.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/features/login/presentation/log_in.dart';
import 'package:teach/features/sign_in/presentation/sign_in.dart';

class ChooseHowToEnter extends StatefulWidget {
 final List imagePath;
 final int check;

 final String description1;
 final String description2;

 const ChooseHowToEnter({
    super.key,
    required this.imagePath,
    required this.description1,
    required this.description2,
 
    required this.check,
  });

  @override
  State<ChooseHowToEnter> createState() => _ChooseHowToEnterState();
}

class _ChooseHowToEnterState extends State<ChooseHowToEnter> {
  var selectedAcount = 6;

  var userName = "";
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          height: getWidth(context) * .3,
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
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                border: Border.all(
                    width: 1,
                    color:
                        selectedAcount == 5 ? Colors.orange : dayBar["blue2"]),
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
                          widget.imagePath[1],
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
                          widget.description1.split(",").first,
                          style: const TextStyle(
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
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                border: Border.all(
                    width: 1,
                    color:
                        selectedAcount == 0 ? Colors.orange : dayBar["blue2"]),
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
                          style: const TextStyle(
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
                onPressed: selectedAcount == 5
                    ? () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUp(
                                
                              ),
                            ));
                      }
                    : selectedAcount == 0 ?       (){
                      Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LogIn(),
                            ));
                    }      : () {
                        lunchAwesomDialoge(
                            DialogType.warning,
                            "error",
                            getDeviceLocale() == "ar"
                                ? Translation()
                                    .translateMe["Arabic"]!["choose_acount"]
                                : Translation()
                                    .translateMe["English"]!["choose_acount"],
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
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
