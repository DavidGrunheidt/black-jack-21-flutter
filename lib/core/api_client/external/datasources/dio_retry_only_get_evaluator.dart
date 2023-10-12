import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

class DioRetryOnlyGetEvaluator extends DefaultRetryEvaluator {
  DioRetryOnlyGetEvaluator(super.retryableStatuses);

  @override
  FutureOr<bool> evaluate(DioException error, int attempt) {
    if (error.requestOptions.method == 'get'.toUpperCase()) return super.evaluate(error, attempt);
    return false;
  }
}
