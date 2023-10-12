import 'package:flutter/material.dart';

enum CustomColors {
  // Primary
  primaryWhite(Color(0xFFEFEFEF)),
  neutralGrey(Color(0xFF666666)),

  // Secondary
  secondaryBlack(Color(0xFF231F20)),
  white(Color(0xFFFFFFFF)),

  // Error
  alertHighlight(Color(0xFFC80000)),
  error(Color(0xFFB3261E)),
  onError(Colors.white),

  lightGreen(Color(0xFF35D32F)),
  darkGreen(Color(0xFF285F2E));

  const CustomColors(this.value);

  final Color value;
}
