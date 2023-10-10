import 'package:black_jack_21_flutter/core/api_client/external/datasources/deck_of_cards_api_client_impl.dart';
import 'package:black_jack_21_flutter/core/flavors/flavors.dart';
import 'package:black_jack_21_flutter/modules/main_game/external/datasources/deck_of_cards_datasource_impl.dart';
import 'package:black_jack_21_flutter/modules/main_game/infra/models/deck_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../utils/dart_define_utils.dart';

void main() {
  return group('DeckOfCardsDatasourceImplE2E', skip: skipIntegrationTests, () {
    appFlavor = Flavor.PROD;

    final apiClient = DeckOfCardsApiClientImpl();
    late final DeckModel deckModel;

    test('getNewDeck retrieves newDeck and parses correctly', () async {
      final datasource = DeckOfCardsDatasourceImpl(apiClient);
      final resp = await datasource.getNewDeck();

      deckModel = resp;

      expect(resp.success, true);
      expect(resp.remaining, 52);
      expect(resp.shuffled, false);
    });

    test('reshuffleDeck returns a shuffled deck', () async {
      final datasource = DeckOfCardsDatasourceImpl(apiClient);
      final resp = await datasource.reshuffleDeck(deckId: deckModel.deckId);

      expect(resp.success, true);
      expect(resp.remaining, 52);
      expect(resp.shuffled, true);
    });

    test('drawCards returns two drawn cards', () async {
      final datasource = DeckOfCardsDatasourceImpl(apiClient);
      final resp = await datasource.drawCards(deckId: deckModel.deckId, count: 2);

      expect(resp.length, 2);
    });
  });
}
