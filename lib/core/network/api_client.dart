// core/network/api_client.dart
import 'package:dio/dio.dart';
import 'api_endpoints.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';

class ApiClient {
  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.addAll([
      AuthInterceptor(),
      ErrorInterceptor(),

      // Chỉ log khi debug, tự tắt ở production
      if (!const bool.fromEnvironment('dart.vm.product'))
        LogInterceptor(requestBody: true, responseBody: true, error: true),
    ]);
  }

  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late final Dio _dio;
  Dio get dio => _dio;
}
