import 'package:flutter/material.dart';

import 'custom_text_style.dart';

final textTheme = TextTheme(
  // Headline & Subtitles
  displayLarge: CustomTextStyle.h1.value,
  displayMedium: CustomTextStyle.h2.value,
  displaySmall: CustomTextStyle.h3.value,
  headlineMedium: CustomTextStyle.h4.value,
  headlineSmall: CustomTextStyle.headline.value,
  titleLarge: CustomTextStyle.headlineBold.value,

  // Body & Captions
  bodyLarge: CustomTextStyle.body1.value,
  bodyMedium: CustomTextStyle.body2.value,
  bodySmall: CustomTextStyle.caption.value,
  labelLarge: CustomTextStyle.button.value,
  labelSmall: CustomTextStyle.subHeadline.value,
);
