import 'package:black_jack_21_flutter/core/exceptions/failure.dart';
import 'package:black_jack_21_flutter/modules/main_game/domain/errors/main_game_errors.dart';
import 'package:black_jack_21_flutter/modules/main_game/domain/repositories/deck_of_cards_repository.dart';
import 'package:black_jack_21_flutter/modules/main_game/domain/usecases/draw_card_to_player_hand.dart';
import 'package:black_jack_21_flutter/modules/main_game/infra/models/card_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../utils/json_utils.dart';
import 'start_new_game_test.mocks.dart';

@GenerateMocks([
  DeckOfCardsRepository,
])
void main() {
  return group('DrawCardToPlayerHand', () {
    final mockDeckOfCardsRepository = MockDeckOfCardsRepository();

    tearDown(() {
      reset(mockDeckOfCardsRepository);
    });

    test('returns Left(DrawCardError)', () async {
      const deckId = '1134123';
      const playerId = '41324';

      Future<Either<Failure, CardModel>> drawCard() => mockDeckOfCardsRepository.drawCard(deckId: deckId);
      when(drawCard()).thenAnswer((_) async => Left(DrawCardError()));

      final resp = await DrawCardToPlayerHandImpl(mockDeckOfCardsRepository).call(deckId: deckId, pileId: playerId);
      resp.fold(
        (left) => expect(left, isA<DrawCardError>()),
        (right) => expect(right, null),
      );

      verify(drawCard());
      verifyNoMoreInteractions(mockDeckOfCardsRepository);
    });

    test('returns Left(AddCardToPileError)', () async {
      const deckId = '1134123';
      const playerId = 'player311d';

      final drawCardJson = (fromJsonFile('draw_card_resp.json')['cards'] as List).first;
      final cardDrawn = CardModel.fromJson(drawCardJson);

      Future<Either<Failure, CardModel>> drawCard() => mockDeckOfCardsRepository.drawCard(deckId: deckId);
      Future<Either<Failure, bool>> addCardToPile() => mockDeckOfCardsRepository.addCardToPile(
            deckId: deckId,
            pileId: playerId,
            cardCode: cardDrawn.code,
          );

      when(drawCard()).thenAnswer((_) async => Right(cardDrawn));
      when(addCardToPile()).thenAnswer((_) async => Left(AddCardToPileError()));

      final resp = await DrawCardToPlayerHandImpl(mockDeckOfCardsRepository).call(deckId: deckId, pileId: playerId);
      resp.fold(
        (left) => expect(left, isA<AddCardToPileError>()),
        (right) => expect(right, null),
      );

      verifyInOrder([drawCard(), addCardToPile()]);
      verifyNoMoreInteractions(mockDeckOfCardsRepository);
    });

    test('returns Left(ListCardsInPileError)', () async {
      const deckId = '1134123';
      const playerId = 'player311d';

      final drawCardJson = (fromJsonFile('draw_card_resp.json')['cards'] as List).first;
      final cardDrawn = CardModel.fromJson(drawCardJson);

      Future<Either<Failure, CardModel>> drawCard() => mockDeckOfCardsRepository.drawCard(deckId: deckId);
      Future<Either<Failure, bool>> addCardToPile() => mockDeckOfCardsRepository.addCardToPile(
            deckId: deckId,
            pileId: playerId,
            cardCode: cardDrawn.code,
          );

      Future<Either<Failure, List<CardModel>>> listCardsInPile() => mockDeckOfCardsRepository.listCardsInPile(
            deckId: deckId,
            pileId: playerId,
          );

      when(drawCard()).thenAnswer((_) async => Right(cardDrawn));
      when(addCardToPile()).thenAnswer((_) async => const Right(true));
      when(listCardsInPile()).thenAnswer((_) async => Left(ListCardsInPileError()));

      final resp = await DrawCardToPlayerHandImpl(mockDeckOfCardsRepository).call(deckId: deckId, pileId: playerId);
      resp.fold(
        (left) => expect(left, isA<ListCardsInPileError>()),
        (right) => expect(right, null),
      );

      verifyInOrder([drawCard(), addCardToPile(), listCardsInPile()]);
      verifyNoMoreInteractions(mockDeckOfCardsRepository);
    });

    test('returns Right with a list of cards', () async {
      const deckId = '1134123';
      const playerId = 'player311d';

      final drawCardJson = (fromJsonFile('draw_card_resp.json')['cards'] as List).first;
      final cardDrawn = CardModel.fromJson(drawCardJson);

      final pileCardsJson = fromJsonFile('list_pile_resp.json')['piles']['table']['cards'] as List;
      final pileCards = pileCardsJson.map((e) => CardModel.fromJson(e as Map<String, dynamic>)).toList();

      Future<Either<Failure, CardModel>> drawCard() => mockDeckOfCardsRepository.drawCard(deckId: deckId);
      Future<Either<Failure, bool>> addCardToPile() => mockDeckOfCardsRepository.addCardToPile(
            deckId: deckId,
            pileId: playerId,
            cardCode: cardDrawn.code,
          );

      Future<Either<Failure, List<CardModel>>> listCardsInPile() => mockDeckOfCardsRepository.listCardsInPile(
            deckId: deckId,
            pileId: playerId,
          );

      when(drawCard()).thenAnswer((_) async => Right(cardDrawn));
      when(addCardToPile()).thenAnswer((_) async => const Right(true));
      when(listCardsInPile()).thenAnswer((_) async => Right(pileCards));

      final resp = await DrawCardToPlayerHandImpl(mockDeckOfCardsRepository).call(deckId: deckId, pileId: playerId);
      resp.fold(
        (left) => expect(left, null),
        (right) => expect(right, pileCards),
      );

      verifyInOrder([drawCard(), addCardToPile(), listCardsInPile()]);
      verifyNoMoreInteractions(mockDeckOfCardsRepository);
    });
  });
}
