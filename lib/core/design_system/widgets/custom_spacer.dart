import 'package:flutter/material.dart';

import '../theme/custom_space.dart';

class CustomSpacer extends StatelessWidget {
  const CustomSpacer._({
    super.key,
    required this.space,
    required this.direction,
  });

  factory CustomSpacer.vertical({
    Key? key,
    required CustomSpace space,
  }) {
    return CustomSpacer._(
      key: key,
      direction: _CustomSpaceDirection.vertical,
      space: space,
    );
  }

  factory CustomSpacer.horizontal({
    Key? key,
    required CustomSpace space,
  }) {
    return CustomSpacer._(
      key: key,
      direction: _CustomSpaceDirection.horizontal,
      space: space,
    );
  }

  final CustomSpace space;
  final _CustomSpaceDirection direction;

  @override
  Widget build(BuildContext context) {
    switch (direction) {
      case _CustomSpaceDirection.vertical:
        return SizedBox(height: space.size);
      case _CustomSpaceDirection.horizontal:
        return SizedBox(width: space.size);
    }
  }
}

enum _CustomSpaceDirection { vertical, horizontal }
