import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../flavors/flavors.dart';
import '../../../utils/app_constants.dart';
import '../../infra/api_client.dart';
import 'dio_retry_only_get_evaluator.dart';

abstract class ApiClientImpl extends ApiClient<Response> {
  Dio get dio;

  Dio createDio(BaseOptions opts, List<Interceptor> interceptors) {
    final dio = Dio(opts);
    if (appFlavor == Flavor.STG) {
      dio.interceptors.addAll([
        PrettyDioLogger(requestHeader: true, requestBody: true, responseHeader: true),
        RetryInterceptor(
          dio: dio,
          logPrint: kDebugMode ? print : null,
          retries: kDioMaxRetries,
          retryDelays: List<Duration>.generate(kDioMaxRetries, (i) => Duration(seconds: i)),
          retryEvaluator: DioRetryOnlyGetEvaluator(defaultRetryableStatuses).evaluate,
        ),
      ]);
    }

    dio.interceptors.addAll(interceptors);
    dio.options.headers['accept'] = 'application/json';
    dio.options.headers['Content-Type'] = 'application/json';
    return dio;
  }

  @override
  Future<Response> get(String path, {dynamic data, Map<String, dynamic>? queryParameters, bool noCache = false}) {
    final noCacheHeader = Options(headers: {'Cache-Control': 'no-cache'});
    return dio.get(path, data: data, queryParameters: queryParameters, options: noCache ? noCacheHeader : null);
  }

  @override
  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) {
    return dio.post(path, data: data, queryParameters: queryParameters, options: options);
  }

  @override
  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) {
    return dio.put(path, data: data, queryParameters: queryParameters);
  }

  @override
  Future<Response> delete(String path, {Map<String, dynamic>? queryParameters}) {
    return dio.delete(path, queryParameters: queryParameters);
  }
}
