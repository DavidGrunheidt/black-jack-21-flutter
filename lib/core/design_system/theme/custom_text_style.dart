import 'package:flutter/material.dart';

enum CustomTextStyle {
  h1(TextStyle(fontFamily: 'ProximaNova', fontSize: 36, fontWeight: FontWeight.w700, height: 1.07)),
  h2(TextStyle(fontFamily: 'ProximaNova', fontSize: 28, fontWeight: FontWeight.w400, height: 1.07)),
  h3(TextStyle(fontFamily: 'ProximaNova', fontSize: 22, fontWeight: FontWeight.w600, height: 1.09)),
  h4(TextStyle(fontFamily: 'ProximaNova', fontSize: 22, fontWeight: FontWeight.w400, height: 1.09)),
  headline(TextStyle(fontFamily: 'ProximaNova', fontSize: 16, fontWeight: FontWeight.w400, height: 1.31)),
  headlineBold(TextStyle(fontFamily: 'ProximaNova', fontSize: 16, fontWeight: FontWeight.w700, height: 1.31)),
  body1(TextStyle(fontFamily: 'ProximaNova', fontSize: 16, fontWeight: FontWeight.w400, height: 1.25)),
  body2(TextStyle(fontFamily: 'ProximaNova', fontSize: 16, fontWeight: FontWeight.w700, height: 1.25)),
  button(TextStyle(fontFamily: 'ProximaNova', fontSize: 16, fontWeight: FontWeight.w700, height: 1.31)),
  infoLink(TextStyle(fontFamily: 'ProximaNova', fontSize: 14, fontWeight: FontWeight.w700, height: 1.25)),
  tileLeadingTitle(TextStyle(fontFamily: 'ProximaNova', fontSize: 14, fontWeight: FontWeight.w600, height: 1.25)),
  tileTrailingInfo(TextStyle(fontFamily: 'ProximaNova', fontSize: 14, fontWeight: FontWeight.w400, height: 1.25)),
  caption(TextStyle(fontFamily: 'ProximaNova', fontSize: 14, fontWeight: FontWeight.w400, height: 1.33)),
  subHeadline(TextStyle(fontFamily: 'ProximaNova', fontSize: 12, fontWeight: FontWeight.w400, height: 1.75)),

  bottomNavLabel(TextStyle(fontFamily: 'ProximaNova', fontSize: 10, fontWeight: FontWeight.w600, height: 1.25));

  const CustomTextStyle(this.value);

  final TextStyle value;
}
