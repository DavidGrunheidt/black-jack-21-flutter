import 'package:dio/dio.dart';

abstract class ApiClient<Resp> {
  Future<Resp> get(String path, {dynamic data, Map<String, dynamic>? queryParameters, bool noCache = false});
  Future<Resp> post(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options});
  Future<Resp> put(String path, {dynamic data, Map<String, dynamic>? queryParameters});
  Future<Resp> delete(String path, {Map<String, dynamic>? queryParameters});
}
