import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach/cubit/color_me/color_me_cubit.dart';

import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/main.dart';
import 'package:uuid/uuid.dart';

class Quize extends StatefulWidget {
  Quize(
      {super.key,
      required this.questions,
      required this.choices,
      required this.answers});
  List questions, choices, answers;
  Map userAnswers = {};
  var isGreen = [];
  var mark = 0;
  @override
  State<Quize> createState() => _QuizeState();
}

class _QuizeState extends State<Quize> {
  @override
  void initState() {
    for (var i = 0; i < widget.questions.length; i++) {
      widget.userAnswers.addAll({i: []});
    }
    super.initState();
  }

  void watchVideo() async {
    // var id = FirebaseAuth.instance.currentUser?.uid;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30))),
        centerTitle: true,
        title: AutoSizeText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          minFontSize: 10,
          maxFontSize: 15,
          getDeviceLocale() == "ar" ? "قيّم فهمك" : "quize",
        ),
        leading: IconButton(
            onPressed: () {
              context.read<ColorMeCubit>().resetMe();
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
            )),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                addAutomaticKeepAlives: true,
                children: List.generate(widget.questions.length, (index) {
                  return SafeArea(child: tex(index));
                }),
              ),
              ElevatedButton(
                onPressed: () {
                  for (var i = 0; i < widget.answers.length; i++) {
                    if (widget.userAnswers[i][0] && widget.answers[i] == "1") {
                      setState(() {
                        widget.mark = widget.mark + 1;
                      });
                    } else if (widget.userAnswers[i][1] &&
                        widget.answers[i] == "2") {
                      setState(() {
                        widget.mark = widget.mark + 1;
                      });
                    } else if (widget.userAnswers[i][2] &&
                        widget.answers[i] == "3") {
                      setState(() {
                        widget.mark = widget.mark + 1;
                      });
                    } else if (widget.userAnswers[i][3] &&
                        widget.answers[i] == "4") {
                      setState(() {
                        widget.mark = widget.mark + 1;
                      });
                    } else if (widget.userAnswers[i][4] &&
                        widget.answers[i] == "5") {
                      setState(() {
                        widget.mark = widget.mark + 1;
                      });
                    }
                  }

                  context.read<ColorMeCubit>().selectMe(widget.answers);
                  if (widget.mark == 0) {
                    lunchAwesomDialoge(
                        DialogType.error,
                        "e",
                        getDeviceLocale() == "ar"
                            ? "لقد فشلت حاول مرّة أخرى!"
                            : "You failed, try again!",
                        context,
                        getWidth(context),
                        getHeight(context));
                    widget.mark = 0;
                  } else if (widget.mark > 0 &&
                      widget.mark < widget.answers.length) {
                    lunchAwesomDialoge(
                        DialogType.warning,
                        "e",
                        getDeviceLocale() == "ar"
                            ? "لقد أخطأت في بعض الأسئلة. حاول مرّة أخرى!"
                            : "You got some questions wrong. Try again!",
                        context,
                        getWidth(context),
                        getHeight(context));
                    widget.mark = 0;
                  } else {
                    lunchAwesomDialoge(
                        DialogType.success,
                        "e",
                        getDeviceLocale() == "ar"
                            ? "مبارك . لقد نجحت😎"
                            : "Congratulations. You have succeeded😎",
                        context,
                        getWidth(context),
                        getHeight(context));
                    widget.mark = 0;
                  }
                },
                child: AutoSizeText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  minFontSize: 10,
                  maxFontSize: 15,
                  getDeviceLocale() == "ar" ? "تحقق" : "verification",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tex(int index) {
    return BlocBuilder<ColorMeCubit, ColorMeState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () {
            context.read<ColorMeCubit>().resetMe();
            Navigator.pop(context);
            return Future.delayed(Duration.zero);
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.question_mark_outlined,
                    ),
                    title: AutoSizeText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 10,
                      maxFontSize: 15,
                      widget.questions[index].toString(),
                    ),
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    CheckboxListTile(
                      value: widget.userAnswers[index].length - 1 < 0
                          ? false
                          : widget.userAnswers[index][0],
                      activeColor: mode
                          ? nightBar["orange"]
                          : const Color.fromARGB(255, 11, 85, 145),
                      checkColor: Colors.white,
                      onChanged: (value) {
                        setState(() {
                          if (widget.userAnswers[index].length - 1 < 0) {
                            widget.userAnswers[index].add(value);
                            widget.userAnswers[index].add(false);
                            widget.userAnswers[index].add(false);
                            widget.userAnswers[index].add(false);
                            widget.userAnswers[index].add(false);
                          } else {
                            widget.userAnswers[index][0] = value;
                            widget.userAnswers[index][1] = false;
                            widget.userAnswers[index][2] = false;
                            widget.userAnswers[index][3] = false;
                            widget.userAnswers[index][4] = false;
                          }
                        });
                      },
                      title: AutoSizeText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 10,
                        maxFontSize: 15,
                        widget.choices[(((index + 1) * 5) - 5)].toString(),
                        style: TextStyle(
                            color: state is SelectMe &&
                                    state.selected[index] == (1).toString()
                                ? Colors.green
                                : (mode ? Colors.white : dayBar["blue2"])),
                      ),
                    ),
                    CheckboxListTile(
                      activeColor: mode
                          ? nightBar["orange"]
                          : const Color.fromARGB(255, 11, 85, 145),
                      checkColor: Colors.white,
                      value: widget.userAnswers[index].length - 1 < 0
                          ? false
                          : widget.userAnswers[index][1],
                      onChanged: (value) {
                        setState(() {
                          if (widget.userAnswers[index].length - 1 < 0) {
                            widget.userAnswers[index].add(false);
                            widget.userAnswers[index].add(value);
                            widget.userAnswers[index].add(false);
                            widget.userAnswers[index].add(false);
                            widget.userAnswers[index].add(false);
                          } else {
                            widget.userAnswers[index][1] = value;
                            widget.userAnswers[index][0] = false;
                            widget.userAnswers[index][2] = false;
                            widget.userAnswers[index][3] = false;
                            widget.userAnswers[index][4] = false;
                          }
                        });
                      },
                      title: AutoSizeText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 10,
                        maxFontSize: 15,
                        widget.choices[(((index + 1) * 5) - 4)].toString(),
                        style: TextStyle(
                            color: state is SelectMe &&
                                    state.selected[index] == (2).toString()
                                ? Colors.green
                                : (mode ? Colors.white : dayBar["blue2"])),
                      ),
                    ),
                    CheckboxListTile(
                      activeColor: mode
                          ? nightBar["orange"]
                          : const Color.fromARGB(255, 11, 85, 145),
                      checkColor: Colors.white,
                      value: widget.userAnswers[index].length - 1 < 0
                          ? false
                          : widget.userAnswers[index][2],
                      onChanged: (value) {
                        setState(() {
                          if (widget.userAnswers[index].length - 1 < 0) {
                            widget.userAnswers[index].add(false);
                            widget.userAnswers[index].add(false);
                            widget.userAnswers[index].add(value);
                            widget.userAnswers[index].add(false);
                            widget.userAnswers[index].add(false);
                          } else {
                            widget.userAnswers[index][2] = value;
                            widget.userAnswers[index][0] = false;
                            widget.userAnswers[index][1] = false;
                            widget.userAnswers[index][3] = false;
                            widget.userAnswers[index][4] = false;
                          }
                        });
                      },
                      title: AutoSizeText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 10,
                        maxFontSize: 15,
                        widget.choices[(((index + 1) * 5) - 3)].toString(),
                        style: TextStyle(
                            color: state is SelectMe &&
                                    state.selected[index] == (3).toString()
                                ? Colors.green
                                : (mode ? Colors.white : dayBar["blue2"])),
                      ),
                    ),
                    CheckboxListTile(
                      activeColor: mode
                          ? nightBar["orange"]
                          : const Color.fromARGB(255, 11, 85, 145),
                      checkColor: Colors.white,
                      value: widget.userAnswers[index].length - 1 < 0
                          ? false
                          : widget.userAnswers[index][3],
                      onChanged: (value) {
                        setState(() {
                          if (widget.userAnswers[index].length - 1 < 0) {
                            widget.userAnswers[index].add(false);
                            widget.userAnswers[index].add(false);
                            widget.userAnswers[index].add(false);
                            widget.userAnswers[index].add(value);
                            widget.userAnswers[index].add(false);
                          } else {
                            if (state is SelectMe) {}
                            widget.userAnswers[index][3] = value;
                            widget.userAnswers[index][0] = false;
                            widget.userAnswers[index][1] = false;
                            widget.userAnswers[index][2] = false;
                            widget.userAnswers[index][4] = false;
                          }
                        });
                      },
                      title: AutoSizeText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 10,
                        maxFontSize: 15,
                        widget.choices[(((index + 1) * 5) - 2)].toString(),
                        style: TextStyle(
                            color: state is SelectMe &&
                                    state.selected[index] == (4).toString()
                                ? Colors.green
                                : (mode ? Colors.white : dayBar["blue2"])),
                      ),
                    ),
                    CheckboxListTile(
                      activeColor: mode
                          ? nightBar["orange"]
                          : const Color.fromARGB(255, 11, 85, 145),
                      checkColor: Colors.white,
                      value: widget.userAnswers[index].length - 1 < 0
                          ? false
                          : widget.userAnswers[index][4],
                      onChanged: (value) {
                        setState(() {
                          if (widget.userAnswers.length - 1 < 0) {
                            widget.userAnswers[index].add(false);
                            widget.userAnswers[index].add(false);
                            widget.userAnswers[index].add(false);
                            widget.userAnswers[index].add(false);
                            widget.userAnswers[index].add(value);
                          } else {
                            widget.userAnswers[index][4] = value;
                            widget.userAnswers[index][0] = false;
                            widget.userAnswers[index][1] = false;
                            widget.userAnswers[index][2] = false;
                            widget.userAnswers[index][3] = false;
                          }
                        });
                      },
                      title: AutoSizeText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 10,
                        maxFontSize: 15,
                        widget.choices[(((index + 1) * 5) - 1)].toString(),
                        style: TextStyle(
                            color: state is SelectMe &&
                                    state.selected[index] == (5).toString()
                                ? Colors.green
                                : (mode ? Colors.white : dayBar["blue2"])),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
