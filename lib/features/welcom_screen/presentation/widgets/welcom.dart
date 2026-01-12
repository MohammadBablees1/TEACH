import 'package:flutter/material.dart';
import 'package:teach/features/welcom_screen/presentation/widgets/choose_how_to_enter.dart';
import 'package:teach/features/welcom_screen/presentation/widgets/hello_widget.dart';

class Welcom extends StatefulWidget {
  final List imagePath;
  final int check;
  final String description1;
  final String description2;
  final VoidCallback onNext;
  final VoidCallback onPrevius;

  const Welcom({
    super.key,
    required this.imagePath,
    required this.description1,
    required this.description2,
    required this.onNext,
    required this.onPrevius,
    required this.check,
  });

  @override
  State<Welcom> createState() => _WelcomState();
}

class _WelcomState extends State<Welcom> {
  var selectedAcount = 6;

  var userName = "";

  @override
  Widget build(BuildContext context) {
    if (widget.check == 1) {
      return HelloWidget(widget: widget);
    } else if (widget.check == 2) {
      return ChooseHowToEnter(
          imagePath: widget.imagePath,
          description1: widget.description1,
          description2: widget.description2,
          check: widget.check);
    } else {
      return Container();
    }
  }
}
