import '../models/deck_model.dart';
import '../models/drawn_card_model.dart';

abstract class DeckOfCardsDatasource {
  Future<DeckModel> getNewDeck();
  Future<DeckModel> reshuffleDeck({required String deckId});
  Future<List<DrawnCardModel>> drawCards({required String deckId, required int count});
}
