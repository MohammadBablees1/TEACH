import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/features/sell_point/data/get_sell_points.dart';
import 'package:teach/features/sell_point/repo/make_phone_call_repo.dart';
import 'package:teach/features/sell_point/repo/open_telegram_repo.dart';
import 'package:teach/features/sell_point/repo/open_whats_app_repo.dart';
import 'package:teach/widgets/no_data_found.dart';

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
        shape: const RoundedRectangleBorder(
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
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
            )),
      ),
      body: FutureBuilder(
        future: GetSellPoints().getSellPoints(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: myImageAsset("images/loading.gif", context),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return SizedBox(
              width: getWidth(context),
              height: getHeight(context),
              child: const Center(
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
                    height: getWidth(context) * .32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
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
                          leading: const Icon(
                            Icons.place,
                            color: Colors.white,
                          ),
                          title: AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            data[index]["name"],
                            style: const TextStyle(
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
                                OpenWhatsAppRepo().openWhatsApp(
                                    data[index]["phone"].toString(), context);
                              },
                              child: Card(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
                                OpenTelegramRepo()
                                    .openTelegram("934652922", context);
                              },
                              child: Card(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
                                MakePhoneCallRepo()
                                    .makePhoneCall("934652922", context);
                              },
                              child: Card(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
}
