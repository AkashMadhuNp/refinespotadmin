import 'dart:ui';



// lib/constants/app_colors.dart
import 'package:flutter/material.dart';

class AppColor {
  static const Color primaryBlue = Color(0xFF1A237E);
  static const Color secondaryBlue = Color(0xFF0D47A1);
  static const Color lightBlue = Color(0xFF2196F3);
  static const Color white = Colors.white;
  static const Color grey = Color(0xFFF5F5F5);

  static const Color Cblue =const Color.fromRGBO(0, 76, 255, 1);
  
  static const LinearGradient mainGradient = LinearGradient(
    colors: [
      Color(0xFF1A237E),
      Color(0xFF0D47A1),
      Color(0xFF1976D2),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [
      Color(0xFF1565C0),
      Color(0xFF1976D2),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}