import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api_client/infra/api_client.dart';
import '../../../../core/utils/app_constants.dart';
import '../../infra/datasources/deck_of_cards_datasource.dart';
import '../../infra/models/deck_model.dart';

@Injectable(as: DeckOfCardsDatasource)
class DeckOfCardsDatasourceImpl implements DeckOfCardsDatasource {
  final ApiClient<Response> apiClient;

  const DeckOfCardsDatasourceImpl(
    @Named(kDeckOfCardsApiClientTag) this.apiClient,
  );

  @override
  Future<DeckModel> getNewDeck() async {
    final resp = await apiClient.get('/new');
    return DeckModel.fromJson(resp.data);
  }
}
