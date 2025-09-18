import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/main.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            AutoSizeText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              minFontSize: 10,
              maxFontSize: 15,
              getDeviceLocale() == "ar"
                  ? "يرجى تحديث التطبيق إلى أحدث إصدار"
                  : "Please update the app to the latest version.",
              style: TextStyle(color: dayBar["blue2"]),
            ),
            SizedBox(
              height: getHeight(context) / 5,
            ),
            ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: dayBar["blue"]),
                onPressed: () async {
                  var url = await supabase
                      .from("last_version")
                      .select()
                      .eq("id", 1)
                      .maybeSingle();

                  await launchUrl(
                    Uri.parse(url!["url"]),
                    mode: LaunchMode
                        .externalApplication, // This will open in Chrome/browser
                  );
                },
                child: AutoSizeText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  minFontSize: 10,
                  maxFontSize: 15,
                  getDeviceLocale() == "ar" ? "تحديث" : "update",
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
      ),
    );
  }
}
