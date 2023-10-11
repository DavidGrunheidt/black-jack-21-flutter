import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/failure.dart';
import '../../infra/models/card_model.dart';
import '../../infra/models/deck_model.dart';

abstract class DeckOfCardsRepository {
  Future<Either<Failure, DeckModel>> getNewDeck();
  Future<Either<Failure, DeckModel>> reshuffleDeck({required String deckId});
  Future<Either<Failure, CardModel>> drawCard({required String deckId});
  Future<Either<Failure, bool>> addCardToPile({
    required String deckId,
    required String pileName,
    required String cardCode,
  });

  Future<Either<Failure, List<CardModel>>> listCardsInPile({required String deckId, required String pileName});
}
