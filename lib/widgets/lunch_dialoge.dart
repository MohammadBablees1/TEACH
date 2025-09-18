import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

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
          style: const TextStyle(),
        ),
      ),
    ),
    animType: AnimType.topSlide,
    dialogType: dialogType,
    // btnOkText: "حسناً",

    // btnOkOnPress: () {

    // },
    //autoDismiss: true,
    // autoHide: Duration(milliseconds: 2000),
  )..show();
}
