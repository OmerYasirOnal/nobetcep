import 'package:dio/dio.dart';

import '../constants.dart';

/// HTTP API Service using Dio
class ApiService {
  ApiService._();

  static final ApiService instance = ApiService._();

  late final Dio _dio;
  bool _isInitialized = false;

  /// Initialize the API service
  void initialize({String? baseUrl}) {
    if (_isInitialized) return;

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? ApiConstants.baseUrl,
        connectTimeout: ApiConstants.timeout,
        receiveTimeout: ApiConstants.timeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add logging interceptor in debug mode
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );

    _isInitialized = true;
  }

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    _ensureInitialized();
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    _ensureInitialized();
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  void _ensureInitialized() {
    if (!_isInitialized) {
      initialize();
    }
  }
}
