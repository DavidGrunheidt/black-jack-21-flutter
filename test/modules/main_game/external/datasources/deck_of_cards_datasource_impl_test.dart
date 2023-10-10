import 'package:black_jack_21_flutter/core/api_client/external/datasources/deck_of_cards_api_client_impl.dart';
import 'package:black_jack_21_flutter/core/flavors/flavors.dart';
import 'package:black_jack_21_flutter/modules/main_game/external/datasources/deck_of_cards_datasource_impl.dart';
import 'package:black_jack_21_flutter/modules/main_game/infra/models/deck_model.dart';
import 'package:black_jack_21_flutter/modules/main_game/infra/models/drawn_card_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../utils/json_utils.dart';
import 'deck_of_cards_datasource_impl_test.mocks.dart';

@GenerateMocks([
  DeckOfCardsApiClientImpl,
])
void main() {
  return group('DeckOfCardsDatasourceImpl', () {
    appFlavor = Flavor.PROD;

    const deckPath = DeckOfCardsDatasourceImpl.deckPath;
    final mockApiClient = MockDeckOfCardsApiClientImpl();

    test('getNewDeck retrieves newDeck and parses correctly', () async {
      final newDeckJson = fromJsonFile('new_deck_resp.json');

      Future<Response> getNewDeck() => mockApiClient.get('$deckPath/new');
      when(getNewDeck()).thenAnswer((_) async => Response(requestOptions: RequestOptions(), data: newDeckJson));

      final datasource = DeckOfCardsDatasourceImpl(mockApiClient);
      final resp = await datasource.getNewDeck();

      expect(resp, DeckModel.fromJson(newDeckJson));
      verify(getNewDeck());
      verifyNoMoreInteractions(mockApiClient);
    });

    test('getNewDeck throws DioException', () async {
      Future<Response> getNewDeck() => mockApiClient.get('$deckPath/new');
      when(getNewDeck()).thenThrow(DioException(requestOptions: RequestOptions()));

      final datasource = DeckOfCardsDatasourceImpl(mockApiClient);
      await expectLater(datasource.getNewDeck(), throwsA(isA<DioException>()));

      verify(getNewDeck());
      verifyNoMoreInteractions(mockApiClient);
    });

    test('reshuffleDeck returns a shuffled deck', () async {
      final shuffledDeckJson = fromJsonFile('reshuffle_deck_resp.json');
      final shuffledDeck = DeckModel.fromJson(shuffledDeckJson);

      Future<Response> reshuffle() => mockApiClient.get('$deckPath/${shuffledDeck.deckId}/shuffle');
      when(reshuffle()).thenAnswer((_) async => Response(requestOptions: RequestOptions(), data: shuffledDeckJson));

      final datasource = DeckOfCardsDatasourceImpl(mockApiClient);
      final resp = await datasource.reshuffleDeck(deckId: shuffledDeck.deckId);

      expect(resp, shuffledDeck);
      verify(reshuffle());
      verifyNoMoreInteractions(mockApiClient);
    });

    test('reshuffleDeck throws DioException', () async {
      const deckId = 'das2dx';

      Future<Response> reshuffle() => mockApiClient.get('$deckPath/$deckId/shuffle');
      when(reshuffle()).thenThrow(DioException(requestOptions: RequestOptions()));

      final datasource = DeckOfCardsDatasourceImpl(mockApiClient);
      await expectLater(datasource.reshuffleDeck(deckId: deckId), throwsA(isA<DioException>()));

      verify(reshuffle());
      verifyNoMoreInteractions(mockApiClient);
    });

    test('drawCards returns two drawn cards', () async {
      const deckId = 'dasdffdf2';
      const count = 2;

      final drawCardsJson = fromJsonFile('draw_card_resp.json');
      final drawCardsJsonList = drawCardsJson['cards'] as List;
      final drawnCards = drawCardsJsonList.map((e) => DrawnCardModel.fromJson(e as Map<String, dynamic>)).toList();

      Future<Response> drawCards() => mockApiClient.get('$deckPath/$deckId/draw?count=$count');
      when(drawCards()).thenAnswer((_) async => Response(requestOptions: RequestOptions(), data: drawCardsJson));

      final datasource = DeckOfCardsDatasourceImpl(mockApiClient);
      final resp = await datasource.drawCards(deckId: deckId, count: count);

      expect(resp, drawnCards);
      verify(drawCards());
      verifyNoMoreInteractions(mockApiClient);
    });

    test('drawCards throws TypeError', () async {
      const deckId = 'dasdffdf2';
      const count = 2;

      Future<Response> drawCards() => mockApiClient.get('$deckPath/$deckId/draw?count=$count');
      when(drawCards()).thenAnswer((_) async => Response(requestOptions: RequestOptions(), data: {}));

      final datasource = DeckOfCardsDatasourceImpl(mockApiClient);
      await expectLater(datasource.drawCards(deckId: deckId, count: count), throwsA(isA<TypeError>()));

      verify(drawCards());
      verifyNoMoreInteractions(mockApiClient);
    });
  });
}
