import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:uuid/uuid.dart';

class Quize extends StatefulWidget {
  Quize(
      {super.key,
      required this.questions,
      required this.choices,
      required this.answers});
  List questions, choices, answers;
  List userAnswers = [];
  var mark = 0;
  @override
  State<Quize> createState() => _QuizeState();
}

class _QuizeState extends State<Quize> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30))),
        centerTitle: true,
        title: Text(
          getDeviceLocale() == "ar" ? "قيّم فهمك" : "quize",
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
            )),
      ),
      body: Column(
        children: [
          ListView(
            shrinkWrap: true,
            addAutomaticKeepAlives: true,
            children: List.generate(
              widget.questions.length,
              (index) => SafeArea(child: tex(index)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              for (var i = 0; i < widget.answers.length; i++) {
                if (widget.userAnswers[(((i + 1) * 3) - 3)] &&
                    widget.answers[i] == "1") {
                  setState(() {
                    widget.mark = widget.mark + 1;
                  });
                } else if (widget.userAnswers[(((i + 1) * 3) - 2)] &&
                    widget.answers[i] == "2") {
                  setState(() {
                    widget.mark = widget.mark + 1;
                  });
                } else if (widget.userAnswers[(((i + 1) * 3) - 1)] &&
                    widget.answers[i] == "3") {
                  setState(() {
                    widget.mark = widget.mark + 1;
                  });
                }
              }

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
            child: Text(
              getDeviceLocale() == "ar" ? "تحقق" : "verification",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(),
          ),
        ],
      ),
    );
  }

  Column tex(int index) {
    return Column(
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
              title: 
                
                  
                   Text(
                    widget.questions[index].toString(),
                  ),
                
              
            ),
          ),
        ),
        Container(
          child: Column(
            children: [
              CheckboxListTile(
                value: widget.userAnswers.length - 1 < ((index + 1) * 3) - 3
                    ? false
                    : widget.userAnswers[(((index + 1) * 3) - 3)],
                activeColor: mode
                    ? nightBar["orange"]
                    : const Color.fromARGB(255, 11, 85, 145),
                onChanged: (value) {
                  setState(() {
                    if (widget.userAnswers.length - 1 <
                        (((index + 1) * 3) - 3)) {
                      widget.userAnswers.add(value);
                      widget.userAnswers.add(false);
                      widget.userAnswers.add(false);
                    } else {
                      widget.userAnswers[(((index + 1) * 3) - 3)] = value;
                      widget.userAnswers[(((index + 1) * 3) - 2)] = false;
                      widget.userAnswers[(((index + 1) * 3) - 1)] = false;
                    }
                  });
                },
                title: Text(widget.choices[(((index + 1) * 3) - 3)].toString()),
              ),
              CheckboxListTile(
                activeColor: mode
                    ? nightBar["orange"]
                    : const Color.fromARGB(255, 11, 85, 145),
                value: widget.userAnswers.length - 1 < ((index + 1) * 3) - 3
                    ? false
                    : widget.userAnswers[(((index + 1) * 3) - 2)],
                onChanged: (value) {
                  setState(() {
                    if (widget.userAnswers.length - 1 <
                        (((index + 1) * 3) - 2)) {
                      widget.userAnswers.add(false);
                      widget.userAnswers.add(value);
                      widget.userAnswers.add(false);
                    } else {
                      widget.userAnswers[(((index + 1) * 3) - 2)] = value;
                      widget.userAnswers[(((index + 1) * 3) - 3)] = false;
                      widget.userAnswers[(((index + 1) * 3) - 1)] = false;
                    }
                  });
                },
                title: Text(widget.choices[(((index + 1) * 3) - 2)].toString()),
              ),
              CheckboxListTile(
                activeColor: mode
                    ? nightBar["orange"]
                    : const Color.fromARGB(255, 11, 85, 145),
                value: widget.userAnswers.length - 1 < ((index + 1) * 3) - 3
                    ? false
                    : widget.userAnswers[(((index + 1) * 3) - 1)],
                onChanged: (value) {
                  setState(() {
                    if (widget.userAnswers.length - 1 <
                        (((index + 1) * 3) - 1)) {
                      widget.userAnswers.add(false);
                      widget.userAnswers.add(false);
                      widget.userAnswers.add(value);
                    } else {
                      widget.userAnswers[(((index + 1) * 3) - 1)] = value;
                      widget.userAnswers[(((index + 1) * 3) - 3)] = false;
                      widget.userAnswers[(((index + 1) * 3) - 2)] = false;
                    }
                  });
                },
                title: Text(widget.choices[(((index + 1) * 3) - 1)].toString()),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
