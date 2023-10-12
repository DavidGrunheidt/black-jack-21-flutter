import 'package:black_jack_21_flutter/core/exceptions/failure.dart';
import 'package:black_jack_21_flutter/core/utils/app_constants.dart';
import 'package:black_jack_21_flutter/core/utils/dartz_utils.dart';
import 'package:black_jack_21_flutter/modules/main_game/domain/errors/main_game_errors.dart';
import 'package:black_jack_21_flutter/modules/main_game/domain/usecases/cards_values_sum.dart';
import 'package:black_jack_21_flutter/modules/main_game/domain/usecases/draw_card_to_player_hand.dart';
import 'package:black_jack_21_flutter/modules/main_game/domain/usecases/start_new_game.dart';
import 'package:black_jack_21_flutter/modules/main_game/infra/models/card_images_model.dart';
import 'package:black_jack_21_flutter/modules/main_game/infra/models/card_model.dart';
import 'package:black_jack_21_flutter/modules/main_game/infra/models/deck_model.dart';
import 'package:black_jack_21_flutter/modules/main_game/presenter/main_game_controller.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../utils/json_utils.dart';
import 'main_game_controller_test.mocks.dart';

@GenerateMocks([
  StartNewGame,
  DrawCardToPlayerHand,
])
void main() {
  return group('MainGameController', () {
    final mockStartNewGame = MockStartNewGame();
    final mockDrawCardToPlayerHand = MockDrawCardToPlayerHand();

    final cardsValueSum = CardsValuesSumImpl();

    const images = CardImagesModel(svg: '', png: '');

    tearDown(() {
      reset(mockStartNewGame);
      reset(mockDrawCardToPlayerHand);
    });

    test('startNewGame increments gameStep and sets currentDeck', () async {
      final shuffledDeck = DeckModel.fromJson(fromJsonFile('shuffle_deck_resp.json'));

      Future<Either<Failure, DeckModel>> startNewGameCall() => mockStartNewGame.call();
      when(startNewGameCall()).thenAnswer((_) async => Right(shuffledDeck));

      final controller = MainGameController(mockStartNewGame, mockDrawCardToPlayerHand, cardsValueSum);
      await controller.startNewGame();

      expect(controller.currentDeck, shuffledDeck);
      expect(controller.gameStep, 1);
      expect(controller.playerCards.isEmpty, true);
      expect(controller.dealerCards.isEmpty, true);
      verify(startNewGameCall());
      verifyNoMoreInteractions(mockStartNewGame);
      verifyZeroInteractions(mockDrawCardToPlayerHand);
    });

    test('drawnCardToCurrentPlayerHand adds card to player hand', () async {
      final shuffledDeck = DeckModel.fromJson(fromJsonFile('shuffle_deck_resp.json'));
      final cards = [
        const CardModel(code: '', image: '', images: images, value: '8', suit: ''),
        const CardModel(code: 'AC', image: '', images: images, value: 'ACE', suit: ''),
      ];

      Future<Either<Failure, List<CardModel>>> drawCardToPlayerHandCall() {
        return mockDrawCardToPlayerHand.call(deckId: shuffledDeck.deckId, pileId: playerPileId);
      }

      when(drawCardToPlayerHandCall()).thenAnswer((_) async => Right(cards));

      final controller = MainGameController(mockStartNewGame, mockDrawCardToPlayerHand, cardsValueSum);
      controller.currentDeck = shuffledDeck;
      controller.gameStep = 1;

      await controller.drawnCardToCurrentPlayerHand();

      expect(controller.dealerCards.isEmpty, true);
      expect(controller.playerCards, cards);
      expect(controller.gameStep, 2);
      verify(drawCardToPlayerHandCall());
      verifyNoMoreInteractions(mockDrawCardToPlayerHand);
      verifyZeroInteractions(mockStartNewGame);
    });

    test('drawnCardToCurrentPlayerHand adds card to dealer hand', () async {
      final shuffledDeck = DeckModel.fromJson(fromJsonFile('shuffle_deck_resp.json'));
      final cards = [
        const CardModel(code: '', image: '', images: images, value: '8', suit: ''),
        const CardModel(code: 'AC', image: '', images: images, value: 'ACE', suit: ''),
      ];

      Future<Either<Failure, List<CardModel>>> drawCardToPlayerHandCall() {
        return mockDrawCardToPlayerHand.call(deckId: shuffledDeck.deckId, pileId: dealerPileId);
      }

      when(drawCardToPlayerHandCall()).thenAnswer((_) async => Right(cards));

      final controller = MainGameController(mockStartNewGame, mockDrawCardToPlayerHand, cardsValueSum);
      controller.currentDeck = shuffledDeck;
      controller.gameStep = 2;

      await controller.drawnCardToCurrentPlayerHand();

      expect(controller.playerCards.isEmpty, true);
      expect(controller.dealerCards, cards);
      expect(controller.gameStep, 3);
      verify(drawCardToPlayerHandCall());
      verifyNoMoreInteractions(mockDrawCardToPlayerHand);
      verifyZeroInteractions(mockStartNewGame);
    });

    test('drawnCardToCurrentPlayerHand returns Left(Failure)', () async {
      final shuffledDeck = DeckModel.fromJson(fromJsonFile('shuffle_deck_resp.json'));

      Future<Either<Failure, List<CardModel>>> drawCardToPlayerHandCall() {
        return mockDrawCardToPlayerHand.call(deckId: shuffledDeck.deckId, pileId: playerPileId);
      }

      when(drawCardToPlayerHandCall()).thenAnswer((_) async => Left(ListCardsInPileError()));

      final controller = MainGameController(mockStartNewGame, mockDrawCardToPlayerHand, cardsValueSum);
      controller.currentDeck = shuffledDeck;
      controller.gameStep = 1;

      final resp = await controller.drawnCardToCurrentPlayerHand();

      expect(resp.leftValue, isA<ListCardsInPileError>());
      expect(controller.dealerCards.isEmpty, true);
      expect(controller.dealerCards.isEmpty, true);
      expect(controller.gameStep, 1);
      verify(drawCardToPlayerHandCall());
      verifyNoMoreInteractions(mockDrawCardToPlayerHand);
      verifyZeroInteractions(mockStartNewGame);
    });

    test('currentRound equals 1', () async {
      final controller = MainGameController(mockStartNewGame, mockDrawCardToPlayerHand, cardsValueSum);
      controller.gameStep = 1;

      expect(controller.currentRound, 1);
      verifyZeroInteractions(mockDrawCardToPlayerHand);
      verifyZeroInteractions(mockStartNewGame);
    });

    test('canStartNewGame equals false', () async {
      final controller = MainGameController(mockStartNewGame, mockDrawCardToPlayerHand, cardsValueSum);
      controller.gameStep = 1;

      expect(controller.canStartNewGame, false);
      verifyZeroInteractions(mockDrawCardToPlayerHand);
      verifyZeroInteractions(mockStartNewGame);
    });

    test('canStartNewGame equals true', () async {
      final controller = MainGameController(mockStartNewGame, mockDrawCardToPlayerHand, cardsValueSum);
      controller.gameStep = 0;

      expect(controller.canStartNewGame, true);
      verifyZeroInteractions(mockDrawCardToPlayerHand);
      verifyZeroInteractions(mockStartNewGame);
    });
  });
}
