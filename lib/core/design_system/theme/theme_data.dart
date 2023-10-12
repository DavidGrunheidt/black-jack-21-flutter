import 'package:flutter/material.dart';

import 'color_scheme.dart';
import 'custom_colors.dart';
import 'text_theme.dart';

final themeData = ThemeData(
  colorScheme: colorScheme,
  textTheme: textTheme,
  scaffoldBackgroundColor: CustomColors.white.value,
);

final darkThemeData = themeData.copyWith(colorScheme: darkColorScheme);
