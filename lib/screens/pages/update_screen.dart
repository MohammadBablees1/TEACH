import 'package:flutter/material.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: getWidth(context),
        height: getHeight(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "images/update.png",
              width: getWidth(context),
              height: getWidth(context),
            ),
            SizedBox(
              height: getHeight(context) / 20,
            ),
            Text(getDeviceLocale() == "ar"
                ? "يرجى تحديث التطبيق إلى أحدث إصدار"
                : "Please update the app to the latest version."),
            SizedBox(
              height: getHeight(context) / 5,
            ),
            ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: dayBar["blue"]),
                onPressed: () async {
                  await launchUrl(
                    Uri.parse("https://pain-assessment.en.uptodown.com/android"),
                    mode: LaunchMode
                        .externalApplication, // This will open in Chrome/browser
                  );
                },
                child: Text(
                  getDeviceLocale() == "ar" ? "تحديث" : "update",
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
      ),
    );
  }
}
