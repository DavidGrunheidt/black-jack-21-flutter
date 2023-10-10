import '../models/deck_model.dart';

abstract class DeckOfCardsDatasource {
  Future<DeckModel> getNewDeck();
}
