import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api_client/infra/api_client.dart';
import '../../../../core/utils/app_constants.dart';
import '../../infra/datasources/deck_of_cards_datasource.dart';
import '../../infra/models/card_model.dart';
import '../../infra/models/deck_model.dart';

@Injectable(as: DeckOfCardsDatasource)
class DeckOfCardsDatasourceImpl implements DeckOfCardsDatasource {
  static const deckPath = '/api/deck';

  final ApiClient<Response> apiClient;

  const DeckOfCardsDatasourceImpl(
    @Named(kDeckOfCardsApiClientTag) this.apiClient,
  );

  @override
  Future<DeckModel> getNewDeck() async {
    final resp = await apiClient.get('$deckPath/new');
    return DeckModel.fromJson(resp.data);
  }

  @override
  Future<DeckModel> shuffleDeck({required String deckId}) async {
    final resp = await apiClient.get('$deckPath/$deckId/shuffle');
    return DeckModel.fromJson(resp.data);
  }

  @override
  Future<List<CardModel>> drawCards({required String deckId, required int count}) async {
    final resp = await apiClient.get('$deckPath/$deckId/draw?count=$count');
    final jsonList = resp.data['cards'] as List;

    return jsonList.map((e) => CardModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<bool> addCardsToPile({
    required String deckId,
    required String pileId,
    required List<String> cardCodes,
  }) async {
    final resp = await apiClient.get('$deckPath/$deckId/pile/$pileId/add?cards=${cardCodes.join(',')}');
    return resp.data['success'];
  }

  @override
  Future<List<CardModel>> listCardsInPile({required String deckId, required String pileId}) async {
    final resp = await apiClient.get('$deckPath/$deckId/pile/$pileId/list');
    final jsonList = resp.data['piles'][pileId]['cards'] as List;

    return jsonList.map((e) => CardModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
