import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../core/dependencies/dependency_injector.dart';
import '../../../core/design_system/theme/custom_asset.dart';
import '../../../core/design_system/theme/custom_space.dart';
import '../../../core/design_system/widgets/custom_spacer.dart';
import '../../../core/exceptions/failure.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/dartz_utils.dart';
import '../../../core/utils/dialog_utils.dart';
import 'main_game_controller.dart';
import 'widgets/player_buttons.dart';
import 'widgets/player_cards_widget.dart';

@RoutePage()
class MainGamePage extends StatefulWidget {
  const MainGamePage({
    super.key,
    this.controller,
  });

  final MainGameController? controller;

  @override
  State<MainGamePage> createState() => _MainGamePageState();
}

class _MainGamePageState extends State<MainGamePage> {
  late final _controller = widget.controller ?? getIt<MainGameController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(CustomAsset.pokerTableBackground.path),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 10, backgroundColor: Colors.transparent),
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          child: Observer(
            builder: (context) {
              return Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: PlayerCardsWidget(
                      cards: _controller.dealerCards,
                      cardsValueSum: _controller.dealerCardsValueSum,
                      playerName: dealerPileId,
                      isInTurn: !_controller.isPlayerTurn,
                    ),
                  ),
                  CustomSpacer.vertical(space: CustomSpace.m),
                  Expanded(
                    flex: 3,
                    child: PlayerCardsWidget(
                      cards: _controller.playerCards,
                      cardsValueSum: _controller.playerCardsValuesSum,
                      playerName: playerPileId,
                      isInTurn: _controller.isPlayerTurn,
                    ),
                  ),
                  CustomSpacer.vertical(space: CustomSpace.s),
                  Expanded(
                    flex: 1,
                    child: PlayerButtons(
                      canStartNewGame: _controller.canStartNewGame,
                      isPlayerTurn: _controller.isPlayerTurn,
                      onNewGameTap: onStartNewGameTap,
                      onDrawCardTap: onDrawCardsTap,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> showErrorDialog(Failure failure) {
    Navigator.of(context).pop();
    return showAppDialog(context: context, content: Text(failure.message));
  }

  Future<void> onStartNewGameTap() async {
    unawaited(showLoadingDialog(context));
    final result = await _controller.startNewGame();
    Navigator.of(context).pop();

    if (result.isLeft()) await showErrorDialog(result.leftValue);
  }

  Future<void> onDrawCardsTap() async {
    // Draw card to player
    unawaited(showLoadingDialog(context));
    final firstResult = await _controller.drawnCardToCurrentPlayerHand();

    if (firstResult.isLeft()) return showErrorDialog(firstResult.leftValue);
    if (await alertIfPlayerWin()) return;

    // Draw card to dealer
    await Future.delayed(const Duration(seconds: 2));
    final secondResult = await _controller.drawnCardToCurrentPlayerHand();

    if (secondResult.isLeft()) return showErrorDialog(firstResult.leftValue);
    if (await alertIfPlayerWin()) return;
    Navigator.of(context).pop();
  }

  Future<bool> alertIfPlayerWin() async {
    final winnerPile = _controller.winnerPileId;
    if (winnerPile == null) return false;

    Navigator.of(context).pop();
    await showAppDialog(context: context, content: Text('$winnerPile is the winner!'));
    return true;
  }
}
