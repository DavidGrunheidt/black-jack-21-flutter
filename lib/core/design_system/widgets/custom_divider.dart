import 'package:flutter/material.dart';

import '../theme/custom_colors.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
    this.height,
    this.thickness,
  });

  final double? height;
  final double? thickness;

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: thickness ?? 2,
      color: CustomColors.neutralGrey.value,
      height: height ?? 2,
    );
  }
}
