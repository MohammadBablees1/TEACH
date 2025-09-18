import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';

lunchAwesomDialoge(DialogType dialogType, title, body, context, width, height) {
  return AwesomeDialog(
    context: context,
    width: width,

    title: "$title",
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AutoSizeText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          minFontSize: 10,
          maxFontSize: 15,
          "$body",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    ),
    animType: AnimType.topSlide,
    dialogType: dialogType,
    // btnOkText: "حسناً",
    dialogBackgroundColor:
        mode ? nightBar["orange"].withOpacity(.5) : Colors.blue.withOpacity(.5),

    // btnOkOnPress: () {

    // },
    //autoDismiss: true,
    // autoHide: Duration(milliseconds: 2000),
  )..show();
}
