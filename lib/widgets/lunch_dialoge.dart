
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
        child: Text(
          "$body",
          style: const TextStyle( ),
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
