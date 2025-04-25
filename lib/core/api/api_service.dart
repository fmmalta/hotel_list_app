import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:hotel_list_app/core/security/secure_api_client.dart';

class APIService {
  late final Dio _dio;
  final String baseUrl;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final CookieJar _cookieJar = CookieJar();
  final SecureApiClient? secureApiClient;

  static const int _defaultTimeoutSeconds = 30;
  static const int _defaultRetryAttempts = 3;
  static const int _defaultRetryDelayMilliseconds = 1000;
  static const String _authTokenKey = 'auth_token';

  APIService({
    required this.baseUrl,
    int timeoutSeconds = _defaultTimeoutSeconds,
    bool enableLogging = true,
    this.secureApiClient,
  }) {
    final String apiUrl = secureApiClient?.enforceHttpsUrl(baseUrl) ?? baseUrl;

    _dio = Dio(
      BaseOptions(
        baseUrl: apiUrl,
        connectTimeout: Duration(seconds: timeoutSeconds),
        receiveTimeout: Duration(seconds: timeoutSeconds),
        responseType: ResponseType.json,
        validateStatus: (status) {
          return status != null && status < 500;
        },
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
      ),
    );

    _dio.interceptors.add(CookieManager(_cookieJar));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (secureApiClient != null) {
            await secureApiClient!.addAuthorizationHeader(options);
            secureApiClient!.addApiKeyHeader(options);
            secureApiClient!.addSecurityHeaders(options);

            if (options.data != null) {
              options.data = secureApiClient!.sanitizeRequestData(options.data);
            }
          } else {
            final token = await _getAuthToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }

            options.headers['X-Frame-Options'] = 'DENY';
            options.headers['X-Content-Type-Options'] = 'nosniff';
            options.headers['X-XSS-Protection'] = '1; mode=block';
          }

          return handler.next(options);
        },
      ),
    );

    if (enableLogging) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout) {
            return handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                error: 'Connection timeout. Please check your internet connection and try again.',
                type: error.type,
              ),
            );
          }

          if (error.response?.statusCode == 401) {
            if (secureApiClient != null) {
              await secureApiClient!.clearTokens();
            } else {
              await _clearAuthToken();
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  Future<String?> _getAuthToken() async {
    if (secureApiClient != null) {
      return await secureApiClient!.getAuthToken();
    }
    return await _secureStorage.read(key: _authTokenKey);
  }

  Future<void> setAuthToken(String token) async {
    if (secureApiClient != null) {
      await secureApiClient!.setAuthToken(token);
    } else {
      await _secureStorage.write(key: _authTokenKey, value: token);
    }
  }

  Future<void> _clearAuthToken() async {
    if (secureApiClient != null) {
      await secureApiClient!.clearTokens();
    } else {
      await _secureStorage.delete(key: _authTokenKey);
    }
  }

  Future<bool> _hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return !connectivityResult.contains(ConnectivityResult.none);
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    int maxRetryAttempts = _defaultRetryAttempts,
  }) async {
    if (!await _hasInternetConnection()) {
      throw DioException(
        requestOptions: RequestOptions(path: path),
        error: 'No internet connection',
        type: DioExceptionType.connectionError,
      );
    }

    int retryCount = 0;
    while (true) {
      try {
        final response = await _dio.get(path, queryParameters: queryParameters, options: options);
        return response;
      } on DioException catch (e) {
        if ((e.type == DioExceptionType.connectionTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.sendTimeout ||
                (e.response?.statusCode != null && e.response!.statusCode! >= 500)) &&
            retryCount < maxRetryAttempts) {
          retryCount++;
          await Future.delayed(Duration(milliseconds: _defaultRetryDelayMilliseconds * retryCount));
          continue;
        }
        rethrow;
      }
    }
  }
}
