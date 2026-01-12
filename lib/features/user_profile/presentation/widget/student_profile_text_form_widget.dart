import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/features/user_profile/presentation/student_profile.dart';

class StudentProfileTextFormWidget extends StatelessWidget {
  final StudentProfile widget;
  final TextEditingController controller;
  final String hintText;
  final int validator;

  const StudentProfileTextFormWidget({
    super.key,
    required this.widget,
    required this.hintText,
    required this.validator,
    required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        switch (validator) {
          case 1:
            return nameValidator(value!);
          case 2:
            return phoneValidator(value!);
          case 3:
            return universityNumberValidator(value!);
          case 4:
            return emailValidator(value!);
        }
        return nameValidator(value!);
      },
      cursorColor: mode ? Colors.white : dayBar["blue"],
      readOnly: validator == 4 ? true : checkManager(),
      controller: controller,
      onChanged: (value) {
        if (validator == 4) {
          widget.emailEditing = true;
        }
        widget.isEditing = true;
      },
      style: TextStyle(
          color: mode ? Colors.white : const Color.fromARGB(255, 11, 85, 145)),
      decoration: InputDecoration(
        prefix: AutoSizeText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          minFontSize: 10,
          maxFontSize: 15,
          hintText,
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
                width: 1,
                color: mode
                    ? nightBar["orange"]
                    : const Color.fromARGB(255, 11, 85, 145))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
                width: 1.5,
                color: mode
                    ? nightBar["orange"]
                    : const Color.fromARGB(255, 11, 85, 145))),
      ),
    );
  }
}
