import 'package:flutter/material.dart';

import '../../../../core/design_system/theme/custom_colors.dart';
import '../../../../core/design_system/theme/custom_space.dart';
import '../../../../core/design_system/theme/custom_text_style.dart';
import '../../../../core/design_system/widgets/custom_spacer.dart';

class PlayerButtons extends StatelessWidget {
  final bool canStartNewGame;
  final bool isPlayerTurn;

  final Future<void> Function() onNewGameTap;
  final Future<void> Function() onDrawCardTap;

  const PlayerButtons({
    super.key,
    required this.canStartNewGame,
    required this.isPlayerTurn,
    required this.onNewGameTap,
    required this.onDrawCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IgnorePointer(
            ignoring: !canStartNewGame,
            child: ElevatedButton(
              onPressed: onNewGameTap,
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                  CustomColors.neutralGrey.value..withOpacity(canStartNewGame ? 1 : 0.5),
                ),
              ),
              child: Text(
                'New game',
                style: CustomTextStyle.headlineBold.value.copyWith(
                  color: CustomColors.primaryWhite.value.withOpacity(canStartNewGame ? 1 : 0.5),
                ),
              ),
            ),
          ),
          CustomSpacer.horizontal(space: CustomSpace.s),
          IgnorePointer(
            ignoring: !isPlayerTurn,
            child: ElevatedButton(
              onPressed: onDrawCardTap,
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                  CustomColors.darkGreen.value..withOpacity(isPlayerTurn ? 1 : 0.5),
                ),
              ),
              child: Text(
                'Draw card',
                style: CustomTextStyle.headlineBold.value.copyWith(
                  color: CustomColors.primaryWhite.value.withOpacity(isPlayerTurn ? 1 : 0.5),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
