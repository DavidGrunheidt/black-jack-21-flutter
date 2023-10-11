import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:firebase_performance_dio/firebase_performance_dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../flavors.dart';
import '../../../utils/app_constants.dart';
import '../../infra/api_client.dart';
import 'api_client_impl.dart';

@Named(kDeckOfCardsApiClientTag)
@Injectable(as: ApiClient)
class DeckOfCardsApiClientImpl extends ApiClientImpl {
  String get baseUrl {
    switch (appFlavor) {
      case Flavor.STG:
      case Flavor.PROD:
        return 'https://deckofcardsapi.com';
    }
  }

  late final BaseOptions opts = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  );

  final interceptors = [
    DioFirebasePerformanceInterceptor(),
    CurlLoggerDioInterceptor(),
  ];

  late final Dio _dio = createDio(opts, interceptors);

  @override
  Dio get dio => _dio;
}
