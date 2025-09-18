import 'dart:math';

import 'package:flutter/material.dart';

Map dayText = {
  "white": Colors.white,
  "black": Colors.black,
  "blue": Colors.blue,
};

Map dayBar = {
  "blue": Colors.blue,
  "blue2": const Color.fromARGB(255, 0, 116, 211),
  "blue3": const Color.fromARGB(255, 1,37,87)
};
Map nightBar = {
  "orange": const Color.fromRGBO(51, 70, 101, 1),
  "buttons": const Color.fromARGB(255, 66, 90, 129),
};
Color getRandomColorWithOpacity() {
  final random = Random();
  return Color.fromRGBO(
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
    1.0, // التعتيم (1.0 = غير شفاف)
  );
}