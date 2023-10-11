import 'package:black_jack_21_flutter/core/api_client/external/datasources/deck_of_cards_api_client_impl.dart';
import 'package:black_jack_21_flutter/core/flavors/flavors.dart';
import 'package:black_jack_21_flutter/modules/main_game/external/datasources/deck_of_cards_datasource_impl.dart';
import 'package:black_jack_21_flutter/modules/main_game/infra/models/card_model.dart';
import 'package:black_jack_21_flutter/modules/main_game/infra/models/deck_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../utils/dart_define_utils.dart';

void main() {
  return group('DeckOfCardsDatasourceImplE2E', skip: skipE2ETests, () {
    appFlavor = Flavor.PROD;

    final apiClient = DeckOfCardsApiClientImpl();
    final datasource = DeckOfCardsDatasourceImpl(apiClient);

    const pileName = 'pile1';
    late DeckModel deckModel;
    late final List<CardModel> drawnCards;

    test('1 - getNewDeck retrieves newDeck and parses correctly', () async {
      deckModel = await datasource.getNewDeck();

      expect(deckModel.success, true);
      expect(deckModel.remaining, 52);
      expect(deckModel.shuffled, false);
    });

    test('2 - reshuffleDeck returns a shuffled deck', () async {
      deckModel = await datasource.reshuffleDeck(deckId: deckModel.deckId);

      expect(deckModel.success, true);
      expect(deckModel.remaining, 52);
      expect(deckModel.shuffled, true);
    });

    test('3 - drawCards returns two drawn cards', () async {
      drawnCards = await datasource.drawCards(deckId: deckModel.deckId, count: 2);

      expect(drawnCards.length, 2);
    });

    test('4 - addCardsToPile adds two drawn cards to pile', () async {
      final success = await datasource.addCardsToPile(
        deckId: deckModel.deckId,
        pileName: pileName,
        cardCodes: drawnCards.map((e) => e.code).toList(),
      );

      expect(success, true);
    });

    test('5 - listCardsInPile lists the two previously added cards inside the pile', () async {
      final pileCards = await datasource.listCardsInPile(deckId: deckModel.deckId, pileName: pileName);
      expect(pileCards, drawnCards);
    });

    test('6 - reshuffleDeck returns all cards to deck', () async {
      deckModel = await datasource.reshuffleDeck(deckId: deckModel.deckId);

      expect(deckModel.success, true);
      expect(deckModel.remaining, 52);
      expect(deckModel.shuffled, true);
    });

    test('7 - listCardsInPile throws NoSuchMethodError since no pile was created after shuffling', () {
      return expectLater(
        datasource.listCardsInPile(deckId: deckModel.deckId, pileName: pileName),
        throwsA(isA<NoSuchMethodError>()),
      );
    });
  });
}
