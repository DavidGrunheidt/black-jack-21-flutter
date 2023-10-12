import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../../core/exceptions/failure.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/dartz_utils.dart';
import '../domain/usecases/cards_values_sum.dart';
import '../domain/usecases/draw_card_to_player_hand.dart';
import '../domain/usecases/start_new_game.dart';
import '../infra/models/card_model.dart';
import '../infra/models/deck_model.dart';

part 'main_game_controller.g.dart';

@singleton
class MainGameController = _MainGameController with _$MainGameController;

abstract class _MainGameController with Store {
  final StartNewGame _startNewGameUsecase;
  final DrawCardToPlayerHand _drawCardToPlayerHandUsecase;
  final CardsValuesSum _cardsValuesSumUsecase;

  _MainGameController(
    this._startNewGameUsecase,
    this._drawCardToPlayerHandUsecase,
    this._cardsValuesSumUsecase,
  );

  @observable
  DeckModel? currentDeck;

  final dealerCards = <CardModel>[].asObservable();
  final playerCards = <CardModel>[].asObservable();

  @computed
  int get dealerCardsValueSum => _cardsValuesSumUsecase.call(cards: dealerCards);

  @computed
  int get playerCardsValuesSum => _cardsValuesSumUsecase.call(cards: playerCards);

  @computed
  String? get winnerPileId {
    if (dealerCardsValueSum > maxPoints) return playerPileId;
    if (dealerCardsValueSum == maxPoints) return dealerPileId;
    if (playerCardsValuesSum > maxPoints) return dealerPileId;
    if (playerCardsValuesSum == maxPoints) return playerPileId;
    return null;
  }

  @observable
  int gameStep = 0;

  @computed
  int get currentRound => (gameStep / numOfPlayers).round();

  @computed
  bool get isPlayerTurn {
    return currentDeck != null && gameStep % numOfPlayers != 0 && winnerPileId == null;
  }

  @computed
  bool get canStartNewGame => gameStep == 0 || winnerPileId != null;

  @action
  Future<Either<Failure, void>> startNewGame() async {
    final result = await _startNewGameUsecase.call(deckId: currentDeck?.deckId);
    if (result.isLeft()) return Left(result.leftValue);

    dealerCards.clear();
    playerCards.clear();

    gameStep = 1;
    currentDeck = result.rightValue;

    return const Right(null);
  }

  @action
  Future<Either<Failure, void>> drawnCardToCurrentPlayerHand() async {
    final pileId = isPlayerTurn ? playerPileId : dealerPileId;
    final result = await _drawCardToPlayerHandUsecase.call(deckId: currentDeck!.deckId, pileId: pileId);
    if (result.isLeft()) return Left(result.leftValue);

    final cards = result.rightValue;
    if (pileId == dealerPileId) {
      dealerCards.clear();
      dealerCards.addAll(cards);
    } else if (pileId == playerPileId) {
      playerCards.clear();
      playerCards.addAll(cards);
    }

    gameStep++;
    return const Right(null);
  }
}
