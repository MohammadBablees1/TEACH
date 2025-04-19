import 'package:flutter/material.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/main.dart';
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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30))),
        centerTitle: true,
        title: Text(
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
              child: Image.asset("images/loading.gif"),
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
                                const Color.fromARGB(255, 11, 85, 145),
                                const Color.fromARGB(255, 4, 96, 172)
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
                          title: Text(
                            data[index]["name"],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          title: Text(
                            data[index]["phone"].toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
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
}
