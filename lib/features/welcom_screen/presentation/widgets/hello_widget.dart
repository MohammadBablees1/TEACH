import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/modules/translate_consts.dart';
import 'package:teach/features/welcom_screen/presentation/widgets/welcom.dart';

class HelloWidget extends StatelessWidget {
  const HelloWidget({
    super.key,
    required this.widget,
  });

  final Welcom widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Image.asset(
          widget.imagePath[0],
          width: getWidth(context),
          height: getWidth(context) * .8,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AutoSizeText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            minFontSize: 10,
            maxFontSize: 15,
            widget.description1,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                overflow: TextOverflow.ellipsis),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AutoSizeText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            minFontSize: 10,
            maxFontSize: 15,
            widget.description2,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                overflow: TextOverflow.ellipsis),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(),
                onPressed: widget.onNext,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: AutoSizeText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    minFontSize: 10,
                    maxFontSize: 15,
                    getDeviceLocale() == "ar"
                        ? Translation().translateMe["Arabic"]!["next_button"]
                        : Translation().translateMe["English"]!["next_button"],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
