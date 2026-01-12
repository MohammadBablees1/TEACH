import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/features/update_password/presentation/manager/crrent_password_visibility/current_password_visibility_cubit.dart';
import 'package:teach/features/update_password/presentation/manager/new_password_visibility/new_password_visibility_cubit.dart';

class UpdatePasswordTextFormFeild extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final int validator;

  const UpdatePasswordTextFormFeild(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.validator});

  @override
  State<UpdatePasswordTextFormFeild> createState() =>
      _UpdatePasswordTextFormFeildState();
}

class _UpdatePasswordTextFormFeildState
    extends State<UpdatePasswordTextFormFeild> {
  bool isVisible = true;
  bool newPasswordVisible = true;
  get iconColor => mode ? Colors.white : dayBar["blue3"];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentPasswordVisibilityCubit,
        CurrentPasswordVisibilityState>(
      builder: (context, currentPasswordState) {
        return BlocBuilder<NewPasswordVisibilityCubit,
            NewPasswordVisibilityState>(
          builder: (context, newPasswordState) {
            return TextFormField(
              validator: (value) {
                switch (widget.validator) {
                  case 1:
                    return nameValidator(value!);
                  case 2:
                    return newPasswordValidator(value!);
                }
                return nameValidator(value!);
              },
              controller: widget.controller,
              maxLines: 1,
              style: TextStyle(color: mode ? Colors.white : dayBar["blue2"]),
              cursorColor: mode ? Colors.white : dayBar["blue2"],
              obscureText: widget.validator == 1
                  ? currentPasswordState is CurrentPasswordVisibility
                      ? currentPasswordState.isVisible
                      : isVisible
                  : widget.validator == 2
                      ? newPasswordState is NewPasswordVisibility
                          ? newPasswordState.isVisible
                          : newPasswordVisible
                      : true,
              decoration: InputDecoration(
                prefixIcon: IconButton(
                    onPressed: () {
                      isVisible = !isVisible;
                      newPasswordVisible = !newPasswordVisible;
                      switch (widget.validator) {
                        case 1:
                          switch (isVisible) {
                            case true:
                              context
                                  .read<CurrentPasswordVisibilityCubit>()
                                  .inVisible();
                              break;
                            case false:
                              context
                                  .read<CurrentPasswordVisibilityCubit>()
                                  .visible();
                              break;
                          }
                        case 2:
                          switch (newPasswordVisible) {
                            case true:
                              context
                                  .read<NewPasswordVisibilityCubit>()
                                  .inVisible();
                              break;
                            case false:
                              context
                                  .read<NewPasswordVisibilityCubit>()
                                  .visible();
                              break;
                          }
                      }
                    },
                    icon: widget.validator == 1
                        ? currentPasswordState is CurrentPasswordVisibility &&
                                currentPasswordState.isVisible
                            ? Icon(Icons.visibility_off, color: iconColor,)
                            :  Icon(Icons.visibility, color: iconColor,)
                        : newPasswordState is NewPasswordVisibility &&
                                newPasswordState.isVisible
                            ?  Icon(Icons.visibility_off, color: iconColor,)
                            :  Icon(Icons.visibility, color: iconColor,)),
                hintText: widget.hintText,
                hintStyle: TextStyle(
                    color: mode
                        // ignore: deprecated_member_use
                        ? Colors.white.withOpacity(.5)
                        : dayBar["blue2"].withOpacity(.5)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      width: .5,
                    )),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      width: .5,
                    )),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      width: 1,
                    )),
              ),
            );
          },
        );
      },
    );
  }


}
