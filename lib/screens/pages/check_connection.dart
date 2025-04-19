import 'package:flutter/material.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({super.key});

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Container(
          decoration: BoxDecoration(
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
                        const Color.fromARGB(255, 198, 198, 199),
                        const Color.fromARGB(255, 147, 148, 148)
                      ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20)),
          width: getWidth(context) / 2,
          height: getWidth(context) / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                child: Image.asset(
                  "images/no_data.jpg",
                  width: getWidth(context) / 2,
                  height: getWidth(context) / 3,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: getWidth(context) / 2,
                height: getHeight(context) / 20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        getDeviceLocale() == "ar"
                            ? "تحقق من اتصالك بالانترنت"
                            : "Check your internet connection",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
