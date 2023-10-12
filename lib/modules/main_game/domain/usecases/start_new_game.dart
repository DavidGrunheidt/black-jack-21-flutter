import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/failure.dart';
import '../../infra/models/deck_model.dart';
import '../repositories/deck_of_cards_repository.dart';

abstract class StartNewGame {
  Future<Either<Failure, DeckModel>> call({String? deckId});
}

@Injectable(as: StartNewGame)
class StartNewGameImpl implements StartNewGame {
  final DeckOfCardsRepository deckOfCardsRepository;

  const StartNewGameImpl(this.deckOfCardsRepository);

  @override
  Future<Either<Failure, DeckModel>> call({String? deckId}) async {
    if (deckId != null) return deckOfCardsRepository.shuffleDeck(deckId: deckId);

    final result = await deckOfCardsRepository.getNewDeck();
    return result.fold<Future<Either<Failure, DeckModel>>>(
      (failure) => Future.value(Left(failure)),
      (newDeck) => deckOfCardsRepository.shuffleDeck(deckId: newDeck.deckId),
    );
  }
}
