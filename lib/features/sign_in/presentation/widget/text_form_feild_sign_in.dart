import 'package:flutter/material.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';

class TextFormFeildSignIn extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final int validator;
  final Icon prefixIcon;
  final TextInputType keyboardType;
  const TextFormFeildSignIn(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.prefixIcon,
      required this.validator,
      required this.keyboardType});

  @override
  State<TextFormFeildSignIn> createState() => _TextFormFeildSignInState();
}

class _TextFormFeildSignInState extends State<TextFormFeildSignIn> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: (value) {
          switch (widget.validator) {
            case 1:
              return emailValidator(value!);
            case 2:
              return universityNumberValidator(value!);
            case 3:
              return newPasswordValidator(value!);
            case 4:
              return codeValidator(value!);
          }
          return nameValidator(value!);
        },
        controller: widget.controller,
        cursorColor: dayBar["blue"],
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(width: .5, color: dayBar["blue"])),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(width: .5, color: dayBar["blue"])),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(width: 1, color: dayBar["blue"])),
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon),
        style: TextStyle(color: dayBar["blue"]),
      ),
    );
  }
}
