import 'package:flutter/material.dart';
import 'package:teach/data/consts/app_const.dart';

class WaitingScreen extends StatelessWidget {
  const WaitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: myImageAsset("images/loading.gif", context)),
        ],
      )),
    );
  }
}
