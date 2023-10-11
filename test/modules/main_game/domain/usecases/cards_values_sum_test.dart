import 'package:black_jack_21_flutter/modules/main_game/domain/usecases/cards_values_sum.dart';
import 'package:black_jack_21_flutter/modules/main_game/infra/models/card_images_model.dart';
import 'package:black_jack_21_flutter/modules/main_game/infra/models/card_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  return group('CardsValuesSum', () {
    const images = CardImagesModel(svg: '', png: '');

    test('cards sums 7', () {
      final cards = [
        const CardModel(code: '', image: '', images: images, value: '2', suit: ''),
        const CardModel(code: '', image: '', images: images, value: '4', suit: ''),
        const CardModel(code: 'AC', image: '', images: images, value: 'ACE', suit: ''),
      ];

      expect(CardsValuesSumImpl().call(cards: cards), 7);
    });

    test('cards sums 20', () {
      final cards = [
        const CardModel(code: 'KH', image: '', images: images, value: 'KING', suit: ''),
        const CardModel(code: 'KC', image: '', images: images, value: 'KING', suit: ''),
      ];

      expect(CardsValuesSumImpl().call(cards: cards), 20);
    });

    test('cards sums 2', () {
      final cards = [
        const CardModel(code: 'AD', image: '', images: images, value: 'ACE', suit: ''),
        const CardModel(code: 'AS', image: '', images: images, value: 'ACE', suit: ''),
      ];

      expect(CardsValuesSumImpl().call(cards: cards), 2);
    });

    test('cards sums 21', () {
      final cards = [
        const CardModel(code: 'AD', image: '', images: images, value: 'ACE', suit: ''),
        const CardModel(code: 'KH', image: '', images: images, value: 'KING', suit: ''),
        const CardModel(code: '9D', image: '', images: images, value: '9', suit: ''),
        const CardModel(code: 'AS', image: '', images: images, value: 'ACE', suit: ''),
      ];

      expect(CardsValuesSumImpl().call(cards: cards), 21);
    });

    test('cards sums 13', () {
      final cards = [
        const CardModel(code: '5S', image: '', images: images, value: '5', suit: ''),
        const CardModel(code: '8D', image: '', images: images, value: '8', suit: ''),
      ];

      expect(CardsValuesSumImpl().call(cards: cards), 13);
    });
  });
}
