import 'package:black_jack_21_flutter/core/api_client/external/datasources/deck_of_cards_api_client_impl.dart';
import 'package:black_jack_21_flutter/flavors.dart';
import 'package:black_jack_21_flutter/modules/main_game/external/datasources/deck_of_cards_datasource_impl.dart';
import 'package:black_jack_21_flutter/modules/main_game/infra/models/card_model.dart';
import 'package:black_jack_21_flutter/modules/main_game/infra/models/deck_model.dart';
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

    tearDown(() {
      reset(mockApiClient);
    });

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

    test('shuffleDeck returns a shuffled deck', () async {
      final shuffledDeckJson = fromJsonFile('shuffle_deck_resp.json');
      final shuffledDeck = DeckModel.fromJson(shuffledDeckJson);

      Future<Response> shuffle() => mockApiClient.get('$deckPath/${shuffledDeck.deckId}/shuffle');
      when(shuffle()).thenAnswer((_) async => Response(requestOptions: RequestOptions(), data: shuffledDeckJson));

      final datasource = DeckOfCardsDatasourceImpl(mockApiClient);
      final resp = await datasource.shuffleDeck(deckId: shuffledDeck.deckId);

      expect(resp, shuffledDeck);
      verify(shuffle());
      verifyNoMoreInteractions(mockApiClient);
    });

    test('shuffleDeck throws DioException', () async {
      const deckId = 'das2dx';

      Future<Response> shuffle() => mockApiClient.get('$deckPath/$deckId/shuffle');
      when(shuffle()).thenThrow(DioException(requestOptions: RequestOptions()));

      final datasource = DeckOfCardsDatasourceImpl(mockApiClient);
      await expectLater(datasource.shuffleDeck(deckId: deckId), throwsA(isA<DioException>()));

      verify(shuffle());
      verifyNoMoreInteractions(mockApiClient);
    });

    test('drawCards returns two drawn cards', () async {
      const deckId = 'dasdffdf2';
      const count = 2;

      final drawCardsJson = fromJsonFile('draw_card_resp.json');
      final drawCardsJsonList = drawCardsJson['cards'] as List;
      final drawnCards = drawCardsJsonList.map((e) => CardModel.fromJson(e as Map<String, dynamic>)).toList();

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

    test('addCardsToPile returns true', () async {
      const deckId = 'dasdffdf2';
      const pileName = 'pile1';
      const cardCodes = ['0D', '4D'];
      final addToPileJson = fromJsonFile('add_to_pile_resp.json');

      Future<Response> addToPile() =>
          mockApiClient.get('$deckPath/$deckId/pile/$pileName/add?cards=${cardCodes.join(',')}');
      when(addToPile()).thenAnswer((_) async => Response(requestOptions: RequestOptions(), data: addToPileJson));

      final datasource = DeckOfCardsDatasourceImpl(mockApiClient);
      final resp = await datasource.addCardsToPile(deckId: deckId, pileId: pileName, cardCodes: cardCodes);

      expect(resp, true);
      verify(addToPile());
      verifyNoMoreInteractions(mockApiClient);
    });

    test('addCardsToPile returns false', () async {
      const deckId = 'd1cdcDsd';
      const pileName = 'pile2';
      const cardCodes = ['1D', '2D'];

      final addToPileJson = fromJsonFile('add_to_pile_resp.json');
      addToPileJson['success'] = false;

      Future<Response> addToPile() =>
          mockApiClient.get('$deckPath/$deckId/pile/$pileName/add?cards=${cardCodes.join(',')}');
      when(addToPile()).thenAnswer((_) async => Response(requestOptions: RequestOptions(), data: addToPileJson));

      final datasource = DeckOfCardsDatasourceImpl(mockApiClient);
      final resp = await datasource.addCardsToPile(deckId: deckId, pileId: pileName, cardCodes: cardCodes);

      expect(resp, false);
      verify(addToPile());
      verifyNoMoreInteractions(mockApiClient);
    });

    test('addCardsToPile throws Exception', () async {
      const deckId = 'c0d31123';
      const pileName = 'pile3';
      const cardCodes = ['3D', '6D'];

      Future<Response> addToPile() =>
          mockApiClient.get('$deckPath/$deckId/pile/$pileName/add?cards=${cardCodes.join(',')}');
      when(addToPile()).thenThrow(Exception());

      await expectLater(
        DeckOfCardsDatasourceImpl(mockApiClient).addCardsToPile(deckId: deckId, pileId: pileName, cardCodes: cardCodes),
        throwsException,
      );

      verify(addToPile());
      verifyNoMoreInteractions(mockApiClient);
    });

    test('listCardsInPile returns empty list', () async {
      const deckId = 'dasd1413f';
      const pileName = 'table';

      final respJson = fromJsonFile('list_pile_empty_cards_resp.json');

      Future<Response> listPile() => mockApiClient.get('$deckPath/$deckId/pile/$pileName/list');
      when(listPile()).thenAnswer((_) async => Response(requestOptions: RequestOptions(), data: respJson));

      final datasource = DeckOfCardsDatasourceImpl(mockApiClient);
      final resp = await datasource.listCardsInPile(deckId: deckId, pileId: pileName);

      expect(resp.isEmpty, true);
      verify(listPile());
      verifyNoMoreInteractions(mockApiClient);
    });

    test('listCardsInPile returns two cards', () async {
      const deckId = 'dasd1413f';
      const pileName = 'table';

      final respJson = fromJsonFile('list_pile_resp.json');
      final pileCardsJson = respJson['piles']['table']['cards'] as List;
      final pileCards = pileCardsJson.map((e) => CardModel.fromJson(e as Map<String, dynamic>)).toList();

      Future<Response> listPile() => mockApiClient.get('$deckPath/$deckId/pile/$pileName/list');
      when(listPile()).thenAnswer((_) async => Response(requestOptions: RequestOptions(), data: respJson));

      final datasource = DeckOfCardsDatasourceImpl(mockApiClient);
      final resp = await datasource.listCardsInPile(deckId: deckId, pileId: pileName);

      expect(resp, pileCards);
      verify(listPile());
      verifyNoMoreInteractions(mockApiClient);
    });

    test('listCardsInPile throws NoSuchMethodError when pile does not exists', () async {
      const deckId = 'dasd1413f';
      const pileName = 'table3124';

      final respJson = fromJsonFile('list_pile_resp.json');

      Future<Response> listPile() => mockApiClient.get('$deckPath/$deckId/pile/$pileName/list');
      when(listPile()).thenAnswer((_) async => Response(requestOptions: RequestOptions(), data: respJson));

      await expectLater(
        DeckOfCardsDatasourceImpl(mockApiClient).listCardsInPile(deckId: deckId, pileId: pileName),
        throwsA(isA<NoSuchMethodError>()),
      );

      verify(listPile());
      verifyNoMoreInteractions(mockApiClient);
    });

    test('listCardsInPile throws DioException', () async {
      const deckId = 'dasd1413f';
      const pileName = 'table3124';

      Future<Response> listPile() => mockApiClient.get('$deckPath/$deckId/pile/$pileName/list');
      when(listPile()).thenThrow(DioException(requestOptions: RequestOptions()));

      await expectLater(
        DeckOfCardsDatasourceImpl(mockApiClient).listCardsInPile(deckId: deckId, pileId: pileName),
        throwsA(isA<DioException>()),
      );

      verify(listPile());
      verifyNoMoreInteractions(mockApiClient);
    });
  });
}
