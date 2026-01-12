import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/features/student-main-screen/presentation/manager/manual_code_loading/manual_code_loading_cubit.dart';

class ManualCode extends StatefulWidget {
  late final GlobalKey<FormState> globalKey;
  late final TextEditingController codeController;
  // ignore: prefer_const_constructors_in_immutables
  ManualCode({super.key});

  @override
  State<ManualCode> createState() => _ManualCodeState();
}

class _ManualCodeState extends State<ManualCode> {
  @override
  void initState() {
    widget.globalKey = GlobalKey();
    widget.codeController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    widget.codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: getWidth(context) * .7,
        height: getWidth(context) * .4,
        child: Form(
          key: widget.globalKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    return codeValidator(value!);
                  },
                  controller: widget.codeController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            BorderSide(width: .5, color: dayBar["blue"])),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            BorderSide(width: .5, color: dayBar["blue"])),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            BorderSide(width: 1, color: dayBar["blue"])),
                    hintText: getDeviceLocale() == "ar"
                        ? "اكتب كود الكورس هنا..."
                        : "Write the course code here...",
                    prefixIcon: IconButton(
                      onPressed: () async {},
                      icon: Icon(
                        Icons.code,
                        color: dayBar["blue2"],
                      ),
                    ),
                  ),
                  style: TextStyle(color: dayBar["blue"]),
                ),
              ),
              BlocBuilder<ManualCodeLoadingCubit, ManualCodeLoadingState>(
                builder: (context, state) {
                  return ElevatedButton(
                      onPressed: () async {
                        if (widget.globalKey.currentState!.validate()) {
                          context.read<ManualCodeLoadingCubit>().startLoading();
                          await context.read<ManualCodeLoadingCubit>().buyCode(
                              context, widget.codeController.text.trim());
                        }
                      },
                      child: state is ManualCodeLoading && state.loading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : AutoSizeText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              minFontSize: 10,
                              maxFontSize: 15,
                              getDeviceLocale() == "ar" ? "شراء" : "Buy",
                              style: const TextStyle(color: Colors.white),
                            ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}