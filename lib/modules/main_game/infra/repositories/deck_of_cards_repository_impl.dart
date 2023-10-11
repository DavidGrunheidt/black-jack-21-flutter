import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/failure.dart';
import '../../domain/errors/main_game_errors.dart';
import '../../domain/repositories/deck_of_cards_repository.dart';
import '../datasources/deck_of_cards_datasource.dart';
import '../models/card_model.dart';
import '../models/deck_model.dart';

@Injectable(as: DeckOfCardsRepository)
class DeckOfCardsRepositoryImpl implements DeckOfCardsRepository {
  final DeckOfCardsDatasource deckOfCardsDatasource;

  const DeckOfCardsRepositoryImpl(this.deckOfCardsDatasource);

  @override
  Future<Either<Failure, DeckModel>> getNewDeck() async {
    try {
      final newDeck = await deckOfCardsDatasource.getNewDeck();
      return Right(newDeck);
    } catch (error, stack) {
      return Left(GetNewDeckError(error: error, stack: stack));
    }
  }

  @override
  Future<Either<Failure, DeckModel>> shuffleDeck({required String deckId}) async {
    try {
      final shuffledDeck = await deckOfCardsDatasource.shuffleDeck(deckId: deckId);
      return Right(shuffledDeck);
    } catch (error, stack) {
      return Left(ShuffleDeckError(error: error, stack: stack));
    }
  }

  @override
  Future<Either<Failure, CardModel>> drawCard({required String deckId}) async {
    try {
      final cards = await deckOfCardsDatasource.drawCards(deckId: deckId, count: 1);
      return Right(cards.first);
    } catch (error, stack) {
      return Left(DrawCardError(error: error, stack: stack));
    }
  }

  @override
  Future<Either<Failure, bool>> addCardToPile({
    required String deckId,
    required String pileId,
    required String cardCode,
  }) async {
    try {
      final success = await deckOfCardsDatasource.addCardsToPile(
        deckId: deckId,
        pileId: pileId,
        cardCodes: [cardCode],
      );

      return Right(success);
    } catch (error, stack) {
      return Left(AddCardToPileError(error: error, stack: stack));
    }
  }

  @override
  Future<Either<Failure, List<CardModel>>> listCardsInPile({
    required String deckId,
    required String pileId,
  }) async {
    try {
      final cards = await deckOfCardsDatasource.listCardsInPile(deckId: deckId, pileId: pileId);
      return Right(cards);
    } catch (error, stack) {
      return Left(ListCardsInPileError(error: error, stack: stack));
    }
  }
}
