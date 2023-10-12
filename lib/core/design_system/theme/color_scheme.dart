import 'package:flutter/material.dart';

import 'custom_colors.dart';

final colorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: CustomColors.neutralGrey.value,
  onPrimary: CustomColors.primaryWhite.value,
  secondary: CustomColors.neutralGrey.value,
  onSecondary: CustomColors.primaryWhite.value,
  error: CustomColors.error.value,
  onError: CustomColors.onError.value,
  background: CustomColors.neutralGrey.value,
  onBackground: CustomColors.primaryWhite.value,
  surface: CustomColors.neutralGrey.value,
  onSurface: CustomColors.primaryWhite.value,
);

final darkColorScheme = colorScheme.copyWith(brightness: Brightness.dark);
