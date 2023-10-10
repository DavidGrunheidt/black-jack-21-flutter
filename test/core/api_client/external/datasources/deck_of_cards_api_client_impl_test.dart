import 'package:black_jack_21_flutter/core/api_client/external/datasources/deck_of_cards_api_client_impl.dart';
import 'package:black_jack_21_flutter/core/flavors/flavors.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DeckOfCardsApiClientImpl', () {
    appFlavor = Flavor.PROD;

    test('GET request performs no retries', () async {
      try {
        await DeckOfCardsApiClientImpl().get('/static/img/back.png');
      } on DioException catch (dioException) {
        expect(dioException.requestOptions.method, 'get'.toUpperCase());
        expect(dioException.requestOptions.extra['ro_attempt'], 0);
      }
    });

    test('POST request performs no retries', () async {
      try {
        await DeckOfCardsApiClientImpl().post('');
      } on DioException catch (dioException) {
        expect(dioException.requestOptions.method, 'post'.toUpperCase());
        expect(dioException.requestOptions.extra['ro_attempt'], null);
      }
    });

    test('PUT request performs no retries', () async {
      try {
        await DeckOfCardsApiClientImpl().put('');
      } on DioException catch (dioException) {
        expect(dioException.requestOptions.method, 'put'.toUpperCase());
        expect(dioException.requestOptions.extra['ro_attempt'], null);
      }
    });

    test('DELETE request performs no retries', () async {
      try {
        await DeckOfCardsApiClientImpl().delete('');
      } on DioException catch (dioException) {
        expect(dioException.requestOptions.method, 'delete'.toUpperCase());
        expect(dioException.requestOptions.extra['ro_attempt'], null);
      }
    });
  });
}
