import 'package:black_jack_21_flutter/core/exceptions/failure.dart';
import 'package:black_jack_21_flutter/modules/main_game/domain/errors/main_game_errors.dart';
import 'package:black_jack_21_flutter/modules/main_game/domain/repositories/deck_of_cards_repository.dart';
import 'package:black_jack_21_flutter/modules/main_game/domain/usecases/start_new_game.dart';
import 'package:black_jack_21_flutter/modules/main_game/infra/models/deck_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../utils/json_utils.dart';
import 'start_new_game_test.mocks.dart';

@GenerateMocks([
  DeckOfCardsRepository,
])
void main() {
  return group('StartNewGame', () {
    final mockDeckOfCardsRepository = MockDeckOfCardsRepository();

    tearDown(() {
      reset(mockDeckOfCardsRepository);
    });

    test('creates new deck when deckId param is null and shuffles it', () async {
      final newDeck = DeckModel.fromJson(fromJsonFile('new_deck_resp.json'));
      final deckShuffled = newDeck.copyWith(shuffled: true);

      Future<Either<Failure, DeckModel>> getNewDeck() => mockDeckOfCardsRepository.getNewDeck();
      Future<Either<Failure, DeckModel>> shuffleDeck() => mockDeckOfCardsRepository.shuffleDeck(deckId: newDeck.deckId);

      when(getNewDeck()).thenAnswer((_) async => Right(newDeck));
      when(shuffleDeck()).thenAnswer((_) async => Right(deckShuffled));

      final resp = await StartNewGameImpl(mockDeckOfCardsRepository).call();

      expect(resp, Right(deckShuffled));
      verifyInOrder([getNewDeck(), shuffleDeck()]);
      verifyNoMoreInteractions(mockDeckOfCardsRepository);
    });

    test('returns Left(GetNewDeckError) when deckId param is null', () async {
      Future<Either<Failure, DeckModel>> getNewDeck() => mockDeckOfCardsRepository.getNewDeck();
      when(getNewDeck()).thenAnswer((_) async => Left(GetNewDeckError()));

      final resp = await StartNewGameImpl(mockDeckOfCardsRepository).call();
      resp.fold(
        (left) => expect(left, isA<GetNewDeckError>()),
        (right) => expect(right, null),
      );

      verify(getNewDeck());
      verifyNoMoreInteractions(mockDeckOfCardsRepository);
    });

    test('retrieves existing deck when deckId param is not null', () async {
      final deck = DeckModel.fromJson(fromJsonFile('new_deck_resp.json'));

      Future<Either<Failure, DeckModel>> shuffleDeck() => mockDeckOfCardsRepository.shuffleDeck(deckId: deck.deckId);
      when(shuffleDeck()).thenAnswer((_) async => Right(deck));

      final resp = await StartNewGameImpl(mockDeckOfCardsRepository).call(deckId: deck.deckId);

      expect(resp, Right(deck));
      verify(shuffleDeck());
      verifyNoMoreInteractions(mockDeckOfCardsRepository);
    });

    test('returns Left(ShuffleDeckError) when deckId param is not null', () async {
      const deckId = '1ed133';

      Future<Either<Failure, DeckModel>> shuffleDeck() => mockDeckOfCardsRepository.shuffleDeck(deckId: deckId);
      when(shuffleDeck()).thenAnswer((_) async => Left(ShuffleDeckError()));

      final resp = await StartNewGameImpl(mockDeckOfCardsRepository).call(deckId: deckId);
      resp.fold(
        (left) => expect(left, isA<ShuffleDeckError>()),
        (right) => expect(right, null),
      );

      verify(shuffleDeck());
      verifyNoMoreInteractions(mockDeckOfCardsRepository);
    });
  });
}
