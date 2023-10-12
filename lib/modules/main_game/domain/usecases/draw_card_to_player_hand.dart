import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/failure.dart';
import '../../../../core/utils/dartz_utils.dart';
import '../../infra/models/card_model.dart';
import '../repositories/deck_of_cards_repository.dart';

abstract class DrawCardToPlayerHand {
  Future<Either<Failure, List<CardModel>>> call({required String deckId, required String pileId});
}

@Injectable(as: DrawCardToPlayerHand)
class DrawCardToPlayerHandImpl implements DrawCardToPlayerHand {
  final DeckOfCardsRepository deckOfCardsRepository;

  const DrawCardToPlayerHandImpl(this.deckOfCardsRepository);

  @override
  Future<Either<Failure, List<CardModel>>> call({required String deckId, required String pileId}) async {
    final drawnResult = await deckOfCardsRepository.drawCard(deckId: deckId);
    if (drawnResult.isLeft()) return Left(drawnResult.leftValue);

    final drawnCard = drawnResult.rightValue;
    final addToPileResult = await deckOfCardsRepository.addCardToPile(
      deckId: deckId,
      pileId: pileId,
      cardCode: drawnCard.code,
    );

    if (addToPileResult.isLeft()) return Left(addToPileResult.leftValue);
    return deckOfCardsRepository.listCardsInPile(deckId: deckId, pileId: pileId);
  }
}
