import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/main.dart';
import 'package:teach/widgets/no_data_found.dart';
import 'package:url_launcher/url_launcher.dart';

class SellPoint extends StatefulWidget {
  const SellPoint({super.key});

  @override
  State<SellPoint> createState() => _SellPointState();
}

class _SellPointState extends State<SellPoint> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30))),
        centerTitle: true,
        title: AutoSizeText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          minFontSize: 10,
          maxFontSize: 15,
          getDeviceLocale() == "ar" ? "نقاط البيع" : "Points of Sale",
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
            )),
      ),
      body: FutureBuilder(
        future: getSellPoints(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: myImageAsset("images/loading.gif", context),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container(
              width: getWidth(context),
              height: getHeight(context),
              child: Center(
                child: NoDataFound(),
              ),
            );
          } else {
            var data = snapshot.data;
            return ListView.builder(
              itemCount: data!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: getWidth(context),
                    height: getWidth(context) * .3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 3.0,
                          spreadRadius: 0.0,
                          offset: Offset(1.0, 1.0),
                        )
                      ],
                      gradient: LinearGradient(
                        colors: mode
                            ? [
                                nightBar["orange"],
                                nightBar["buttons"],
                              ]
                            : [
                                const Color.fromARGB(255, 1, 37, 87),
                                const Color.fromARGB(255, 6, 46, 102)
                              ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.place,
                            color: Colors.white,
                          ),
                          title: AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            data[index]["name"],
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ListTile(
                            title: Row(
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () async {
                                _openWhatsApp(data[index]["phone"].toString());
                              },
                              child: Card(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                color:
                                    mode ? nightBar["orange"] : dayBar["blue2"],
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
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                color:
                                    mode ? nightBar["orange"] : dayBar["blue2"],
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
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                color:
                                    mode ? nightBar["orange"] : dayBar["blue2"],
                                elevation: 5,
                                child: Image.asset(
                                  "images/mobile.png",
                                  width: getWidth(context) * .1,
                                  height: getWidth(context) * .1,
                                ),
                              ),
                            ),
                          ],
                        )),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List> getSellPoints() async {
    var data = await supabase.from("sell_point").select("*");

    return data;
  }

  Future<void> _launchWhatsApp(phoneNumber) async {
    // تنظيف رقم الهاتف (إزالة المسافات والرموز)
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[+\s-]'), '');

    // إنشاء رابط WhatsApp
    final url = 'https://wa.me/$cleanedNumber';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _makePhoneCall(String phoneNumber) async {
    final url = 'tel:+963$phoneNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch phone dialer';
    }
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
}
