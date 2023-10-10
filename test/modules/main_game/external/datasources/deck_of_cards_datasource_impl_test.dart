import 'package:black_jack_21_flutter/core/api_client/external/datasources/deck_of_cards_api_client_impl.dart';
import 'package:black_jack_21_flutter/core/flavors/flavors.dart';
import 'package:black_jack_21_flutter/modules/main_game/external/datasources/deck_of_cards_datasource_impl.dart';
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
    final mockApiClient = MockDeckOfCardsApiClientImpl();

    test('getNewDeck retrieves newDeck and parses correctly', () async {
      final newDeckJson = fromJsonFile('new_deck_resp.json');

      Future<Response> getNewDeck() => mockApiClient.get('/new');
      when(getNewDeck()).thenAnswer((_) async => Response(requestOptions: RequestOptions(), data: newDeckJson));

      final datasource = DeckOfCardsDatasourceImpl(mockApiClient);
      final resp = await datasource.getNewDeck();

      expect(resp, DeckModel.fromJson(newDeckJson));
      verify(getNewDeck());
      verifyNoMoreInteractions(mockApiClient);
    });

    test('getNewDeck throws exception', () async {
      Future<Response> getNewDeck() => mockApiClient.get('/new');
      when(getNewDeck()).thenThrow(DioException(requestOptions: RequestOptions()));

      final datasource = DeckOfCardsDatasourceImpl(mockApiClient);
      await expectLater(datasource.getNewDeck(), throwsA(isA<DioException>()));

      verify(getNewDeck());
      verifyNoMoreInteractions(mockApiClient);
    });
  });
}
