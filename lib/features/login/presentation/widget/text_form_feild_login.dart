import 'package:flutter/material.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';

class TextFormFeildLogIn extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final int validator;
  final Widget prefixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  const TextFormFeildLogIn(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.prefixIcon,
      required this.validator,
      required this.keyboardType,
      required this.obscureText});

  @override
  State<TextFormFeildLogIn> createState() => _TextFormFeildLogInState();
}

class _TextFormFeildLogInState extends State<TextFormFeildLogIn> {
  String confirmPasswordVariable = "";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        obscureText: widget.obscureText,
        validator: (value) {
          switch (widget.validator) {
            case 1:
              return customNameValidator(value!);
            case 2:
              return phoneValidator(value!);
            case 3:
              return universityNumberValidator(value!);
            case 4:
              return emailValidator(value!);
            case 5:
              confirmPasswordVariable = value!;
              return newPasswordValidator(value);
            case 6:
              return confirmPassword(value!, confirmPasswordVariable);
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
