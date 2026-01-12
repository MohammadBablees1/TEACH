import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/features/sell_point/repo/make_phone_call_repo.dart';
import 'package:teach/features/sell_point/repo/open_telegram_repo.dart';
import 'package:teach/features/sell_point/repo/open_whats_app_repo.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mode ? nightBar["orange"] : dayBar["blue3"],
      body: Column(
        children: [
          SizedBox(
            height: getWidth(context) * .4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: getWidth(context) * .2,
                  height: getWidth(context) * .2,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset("images/icon.jpg")),
                ),
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
                            ? "حول التطبيق"
                            : "About the app",
                        style: TextStyle(
                            fontSize: getWidth(context) * .05,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: getHeight(context) - (getWidth(context) * .4),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: mode ? const Color.fromRGBO(0, 0, 0, 1) : Colors.white),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: getWidth(context) * .1,
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    color: mode ? nightBar["orange"] : dayBar["blue3"],
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: AutoSizeText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 5,
                        maxFontSize: 15,
                        getDeviceLocale() == "ar"
                            ? "تطبيقنا يساعدك على إنجاز مهامك بسهولة..."
                            : "Our app helps you get your tasks done easily...",
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: getWidth(context) * .1,
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    color: mode ? nightBar["orange"] : dayBar["blue3"],
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            getDeviceLocale() == "ar"
                                ? "تواصل معنا على :"
                                : "Contact us on:",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(
                            height: getWidth(context) * .05,
                          ),
                          SizedBox(
                            width: getWidth(context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () async {
                                 await  OpenWhatsAppRepo().openWhatsApp("934652922", context);
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    color: mode
                                        ? nightBar["orange"]
                                        : dayBar["blue2"],
                                    elevation: 5,
                                    child: Image.asset(
                                      "images/whatsapp.png",
                                      width: getWidth(context) * .1,
                                      height: getWidth(context) * .1,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () async{
                                await  OpenTelegramRepo().openTelegram("934652922", context);
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    color: mode
                                        ? nightBar["orange"]
                                        : dayBar["blue2"],
                                    elevation: 5,
                                    child: Image.asset(
                                      "images/telegram.png",
                                      width: getWidth(context) * .1,
                                      height: getWidth(context) * .1,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () async{
                                 await MakePhoneCallRepo().makePhoneCall("934652922", context);
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    color: mode
                                        ? nightBar["orange"]
                                        : dayBar["blue2"],
                                    elevation: 5,
                                    child: Image.asset(
                                      "images/mobile.png",
                                      width: getWidth(context) * .1,
                                      height: getWidth(context) * .1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: getWidth(context) * .1,
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    color: mode ? nightBar["orange"] : dayBar["blue3"],
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: getWidth(context) * .7,
                        child: Column(
                          children: [
                            SizedBox(
                              width: getWidth(context) * .7,
                              height: getWidth(context) * .3,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                                child: Image.asset(
                                  "images/company.jpg",
                                  width: getWidth(context) * .6,
                                  height: getWidth(context) * .3,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AutoSizeText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  minFontSize: 3,
                                  maxFontSize: 16,
                                  getDeviceLocale() == "ar"
                                      ? "طوّر بحبّ ❤️ بواسطة "
                                      : "Developed by ",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green),
                                  onPressed: () async{
                                 await OpenWhatsAppRepo().openWhatsApp("988164017", context);
                                  },
                                  child: const AutoSizeText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    minFontSize: 10,
                                    maxFontSize: 15,
                                    "Bablees",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: getWidth(context) * .1,
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    color: mode ? nightBar["orange"] : dayBar["blue3"],
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: AutoSizeText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 10,
                        maxFontSize: 15,
                        getDeviceLocale() == "ar"
                            ? "إصدار التطبيق : $appVersion"
                            : "App version : $appVersion",
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: getWidth(context) * .1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}