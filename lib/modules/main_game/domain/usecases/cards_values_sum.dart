import 'package:injectable/injectable.dart';

import '../../infra/models/card_model.dart';

abstract class CardsValuesSum {
  int call({required List<CardModel> cards});
}

@Injectable(as: CardsValuesSum)
class CardsValuesSumImpl implements CardsValuesSum {
  @override
  int call({required List<CardModel> cards}) {
    final intValues = cards.map((card) {
      if (card.code.startsWith('A')) return 1;
      try {
        return int.parse(card.value);
      } catch (_) {
        return 10;
      }
    });

    return intValues.reduce((val, el) => val + el);
  }
}
