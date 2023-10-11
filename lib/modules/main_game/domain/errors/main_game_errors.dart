import '../../../../core/exceptions/failure.dart';

class GetNewDeckError extends Failure {
  GetNewDeckError({
    super.message = 'Não foi possível recuperar um novo baralho',
    super.error,
    super.stack,
  });

  @override
  String get code => 'GET_NEW_DECK_ERROR';
}

class ReshuffleDeckError extends Failure {
  ReshuffleDeckError({
    super.message = 'Não foi possível embaralhar este baralho',
    super.error,
    super.stack,
  });

  @override
  String get code => 'SHUFFLE_DECK_ERROR';
}

class DrawCardError extends Failure {
  DrawCardError({
    super.message = 'Não foi possível puxar uma carta do baralho',
    super.error,
    super.stack,
  });

  @override
  String get code => 'DRAWN_CARD_ERROR';
}

class AddCardToPileError extends Failure {
  AddCardToPileError({
    super.message = 'Não foi possível puxar uma carta para a mão do jogador da vez',
    super.error,
    super.stack,
  });

  @override
  String get code => 'ADD_CARD_TO_PILE_ERROR';
}

class ListCardsInPileError extends Failure {
  ListCardsInPileError({
    super.message = 'Não foi possível listar as cartas da mão do jogador da vez',
    super.error,
    super.stack,
  });

  @override
  String get code => 'LIST_CARDS_IN_PILE_ERROR';
}
