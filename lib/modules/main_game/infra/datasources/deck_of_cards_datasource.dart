import '../models/card_model.dart';
import '../models/deck_model.dart';

abstract class DeckOfCardsDatasource {
  Future<DeckModel> getNewDeck();
  Future<DeckModel> reshuffleDeck({required String deckId});
  Future<List<CardModel>> drawCards({required String deckId, required int count});
  Future<void> addToPile({required String deckId, required String pileName, required List<String> cardCodes});
  Future<List<CardModel>> listPile({required String deckId, required String pileName});
}
