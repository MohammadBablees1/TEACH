import 'dart:ui';

import 'package:flutter/material.dart';

class CurvedAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30); // بداية القوس
    path.quadraticBezierTo(
      size.width / 2, 
      size.height + 30, // ارتفاع القوس
      size.width, 
      size.height - 30 // نهاية القوس
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}