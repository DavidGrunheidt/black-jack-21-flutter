import '../models/card_model.dart';
import '../models/deck_model.dart';

abstract class DeckOfCardsDatasource {
  Future<DeckModel> getNewDeck();
  Future<DeckModel> shuffleDeck({required String deckId});
  Future<List<CardModel>> drawCards({required String deckId, required int count});
  Future<bool> addCardsToPile({required String deckId, required String pileId, required List<String> cardCodes});
  Future<List<CardModel>> listCardsInPile({required String deckId, required String pileId});
}
