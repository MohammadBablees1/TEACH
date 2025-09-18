import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mode ? nightBar["orange"] : dayBar["blue3"],
      body: Column(
        children: [
          Container(
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
                borderRadius: BorderRadius.only(
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
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    color: mode ? nightBar["orange"] : dayBar["blue3"],
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: AutoSizeText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 5,
                        maxFontSize: 15,
                        getDeviceLocale() == "ar"
                            ? "تطبيقنا يساعدك على إنجاز مهامك بسهولة..."
                            : "Our app helps you get your tasks done easily...",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: getWidth(context) * .1,
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    color: mode ? nightBar["orange"] : dayBar["blue3"],
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(16),
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
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(
                            height: getWidth(context) * .05,
                          ),
                          Container(
                            width: getWidth(context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () async {
                                    _openWhatsApp("934652922");
                                  },
                                  child: Card(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
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
                                  onTap: () {
                                    _openTelegram("934652922");
                                  },
                                  child: Card(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
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
                                  onTap: () {
                                    _makePhoneCall("934652922");
                                  },
                                  child: Card(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
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
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    color: mode ? nightBar["orange"] : dayBar["blue3"],
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Container(
                        width: getWidth(context) * .6,
                        child: Column(
                          children: [
                            Container(
                              width: getWidth(context) * .6,
                              height: getWidth(context) * .3,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
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
                                  minFontSize: 10,
                                  maxFontSize: 15,
                                  getDeviceLocale() == "ar"
                                      ? "طوّر بحبّ ❤️ بواسطة "
                                      : "Developed by ",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green),
                                  onPressed: () {
                                    _openWhatsApp("988164017");
                                  },
                                  child: AutoSizeText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    minFontSize: 10,
                                    maxFontSize: 15,
                                    "Bablees",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255)),
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
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    color: mode ? nightBar["orange"] : dayBar["blue3"],
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: AutoSizeText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 10,
                        maxFontSize: 15,
                        getDeviceLocale() == "ar"
                            ? "إصدار التطبيق : $appVersion"
                            : "App version : $appVersion",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.white),
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

  // Open WhatsApp with a specific number
  void _openWhatsApp(String phoneNumber) async {
    final url = 'https://wa.me/+963$phoneNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch WhatsApp';
    }
  }

  // Open Telegram with a specific username
  void _openTelegram(String phoneNumber) async {
    // Format: "tg://resolve?phone=+1234567890"
    final url = 'tg://resolve?phone=+963$phoneNumber';

    // Try opening the Telegram app first
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      // Fallback: Open Telegram in a browser if the app isn't installed
      final webUrl =
          'https://t.me/+963$phoneNumber'; // Some versions support this
      if (await canLaunchUrl(Uri.parse(webUrl))) {
        await launchUrl(Uri.parse(webUrl));
      } else {
        throw 'Could not launch Telegram';
      }
    }
  }

  // Make a phone call
  void _makePhoneCall(String phoneNumber) async {
    final url = 'tel:+963$phoneNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch phone dialer';
    }
  }
}
