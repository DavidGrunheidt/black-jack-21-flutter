import 'package:black_jack_21_flutter/modules/main_game/domain/errors/main_game_errors.dart';
import 'package:black_jack_21_flutter/modules/main_game/infra/datasources/deck_of_cards_datasource.dart';
import 'package:black_jack_21_flutter/modules/main_game/infra/models/card_model.dart';
import 'package:black_jack_21_flutter/modules/main_game/infra/models/deck_model.dart';
import 'package:black_jack_21_flutter/modules/main_game/infra/repositories/deck_of_cards_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../utils/json_utils.dart';
import 'deck_of_cards_repository_impl_test.mocks.dart';

@GenerateMocks([
  DeckOfCardsDatasource,
])
void main() {
  return group('DeckOfCardsRepositoryImpl', () {
    final mockDatasource = MockDeckOfCardsDatasource();

    tearDown(() {
      reset(mockDatasource);
    });

    test('getNewDeck returns Right(DeckModel)', () async {
      final newDeck = DeckModel.fromJson(fromJsonFile('new_deck_resp.json'));

      Future<DeckModel> getNewDeck() => mockDatasource.getNewDeck();
      when(getNewDeck()).thenAnswer((_) async => newDeck);

      final resp = await DeckOfCardsRepositoryImpl(mockDatasource).getNewDeck();

      expect(resp, Right(newDeck));
      verify(getNewDeck());
      verifyNoMoreInteractions(mockDatasource);
    });

    test('getNewDeck returns Left(Failure)', () async {
      Future<DeckModel> getNewDeck() => mockDatasource.getNewDeck();
      when(getNewDeck()).thenThrow(Exception());

      final resp = await DeckOfCardsRepositoryImpl(mockDatasource).getNewDeck();
      resp.fold(
        (left) => expect(left, isA<GetNewDeckError>()),
        (right) => expect(right, null),
      );

      verify(getNewDeck());
      verifyNoMoreInteractions(mockDatasource);
    });

    test('reshuffleDeck returns Right(DeckModel)', () async {
      final shuffledDeck = DeckModel.fromJson(fromJsonFile('reshuffle_deck_resp.json'));

      Future<DeckModel> reshuffle() => mockDatasource.reshuffleDeck(deckId: shuffledDeck.deckId);
      when(reshuffle()).thenAnswer((_) async => shuffledDeck);

      final resp = await DeckOfCardsRepositoryImpl(mockDatasource).reshuffleDeck(deckId: shuffledDeck.deckId);

      expect(resp, Right(shuffledDeck));
      verify(reshuffle());
      verifyNoMoreInteractions(mockDatasource);
    });

    test('reshuffleDeck returns Left(Failure)', () async {
      const deckId = 'dce141ff';

      Future<DeckModel> reshuffle() => mockDatasource.reshuffleDeck(deckId: deckId);
      when(reshuffle()).thenThrow(TypeError());

      final resp = await DeckOfCardsRepositoryImpl(mockDatasource).reshuffleDeck(deckId: deckId);
      resp.fold(
        (left) => expect(left, isA<ReshuffleDeckError>()),
        (right) => expect(right, null),
      );

      verify(reshuffle());
      verifyNoMoreInteractions(mockDatasource);
    });

    test('drawCards returns Right(CardModel)', () async {
      const deckId = 'dasdffdf2';

      final drawCardsJson = fromJsonFile('draw_card_resp.json');
      final drawCardsJsonList = (drawCardsJson['cards'] as List).sublist(0, 1);
      final drawnCards = drawCardsJsonList.map((e) => CardModel.fromJson(e as Map<String, dynamic>)).toList();

      Future<List<CardModel>> drawCards() => mockDatasource.drawCards(deckId: deckId, count: 1);
      when(drawCards()).thenAnswer((_) async => drawnCards);

      final resp = await DeckOfCardsRepositoryImpl(mockDatasource).drawCard(deckId: deckId);

      expect(resp, Right(drawnCards.first));
      verify(drawCards());
      verifyNoMoreInteractions(mockDatasource);
    });

    test('drawCards returns Left(Failure)', () async {
      const deckId = '41d1de';

      Future<List<CardModel>> drawCards() => mockDatasource.drawCards(deckId: deckId, count: 1);
      when(drawCards()).thenThrow(DioException(requestOptions: RequestOptions()));

      final resp = await DeckOfCardsRepositoryImpl(mockDatasource).drawCard(deckId: deckId);
      resp.fold(
        (left) => expect(left, isA<DrawCardError>()),
        (right) => expect(right, null),
      );

      verify(drawCards());
      verifyNoMoreInteractions(mockDatasource);
    });

    test('addCardsToPile returns Right(true)', () async {
      const deckId = 'dasdffdf2';
      const pileName = 'pile1';
      const cardCode = '1D';

      Future<bool> addToPile() {
        return mockDatasource.addCardsToPile(deckId: deckId, pileName: pileName, cardCodes: [cardCode]);
      }

      when(addToPile()).thenAnswer((_) async => true);

      final resp = await DeckOfCardsRepositoryImpl(mockDatasource).addCardToPile(
        deckId: deckId,
        pileName: pileName,
        cardCode: cardCode,
      );

      expect(resp, const Right(true));
      verify(addToPile());
      verifyNoMoreInteractions(mockDatasource);
    });

    test('addCardsToPile returns Right(false)', () async {
      const deckId = '32r42fd';
      const pileName = 'pile1';
      const cardCode = '5D';

      Future<bool> addToPile() {
        return mockDatasource.addCardsToPile(deckId: deckId, pileName: pileName, cardCodes: [cardCode]);
      }

      when(addToPile()).thenAnswer((_) async => false);

      final resp = await DeckOfCardsRepositoryImpl(mockDatasource).addCardToPile(
        deckId: deckId,
        pileName: pileName,
        cardCode: cardCode,
      );

      expect(resp, const Right(false));
      verify(addToPile());
      verifyNoMoreInteractions(mockDatasource);
    });

    test('addCardsToPile returns Left(Failure)', () async {
      const deckId = '41f134';
      const pileName = 'table23';
      const cardCode = '0D';

      Future<bool> addToPile() {
        return mockDatasource.addCardsToPile(deckId: deckId, pileName: pileName, cardCodes: [cardCode]);
      }

      when(addToPile()).thenThrow(Exception());

      final resp = await DeckOfCardsRepositoryImpl(mockDatasource).addCardToPile(
        deckId: deckId,
        pileName: pileName,
        cardCode: cardCode,
      );

      resp.fold(
        (left) => expect(left, isA<AddCardToPileError>()),
        (right) => expect(right, null),
      );

      verify(addToPile());
      verifyNoMoreInteractions(mockDatasource);
    });

    test('listCardsInPile returns Right([])', () async {
      const deckId = 'dasd1413f';
      const pileName = 'table';

      Future<List<CardModel>> listPile() => mockDatasource.listCardsInPile(deckId: deckId, pileName: pileName);
      when(listPile()).thenAnswer((_) async => []);

      final resp = await DeckOfCardsRepositoryImpl(mockDatasource).listCardsInPile(deckId: deckId, pileName: pileName);
      resp.fold(
        (left) => expect(left, null),
        (right) => expect(right.isEmpty, true),
      );

      verify(listPile());
      verifyNoMoreInteractions(mockDatasource);
    });

    test('listCardsInPile returns Right([CardModel, CardModel])', () async {
      const deckId = 'dasd1413f';
      const pileName = 'table';

      final respJson = fromJsonFile('list_pile_resp.json');
      final pileCardsJson = respJson['piles']['table']['cards'] as List;
      final pileCards = pileCardsJson.map((e) => CardModel.fromJson(e as Map<String, dynamic>)).toList();

      Future<List<CardModel>> listPile() => mockDatasource.listCardsInPile(deckId: deckId, pileName: pileName);
      when(listPile()).thenAnswer((_) async => pileCards);

      final resp = await DeckOfCardsRepositoryImpl(mockDatasource).listCardsInPile(deckId: deckId, pileName: pileName);

      expect(resp, Right(pileCards));
      verify(listPile());
      verifyNoMoreInteractions(mockDatasource);
    });

    test('listCardsInPile returns Left(Failure)', () async {
      const deckId = 'dasd1413f';
      const pileName = 'table3124';

      Future<List<CardModel>> listPile() => mockDatasource.listCardsInPile(deckId: deckId, pileName: pileName);
      when(listPile()).thenThrow(UnsupportedError(''));

      final resp = await DeckOfCardsRepositoryImpl(mockDatasource).listCardsInPile(deckId: deckId, pileName: pileName);
      resp.fold(
        (left) => expect(left, isA<ListCardsInPileError>()),
        (right) => expect(right, null),
      );

      verify(listPile());
      verifyNoMoreInteractions(mockDatasource);
    });
  });
}
