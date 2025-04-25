import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

class SecureApiClient {
  final bool enforceHttps;
  final String apiKey;
  final FlutterSecureStorage secureStorage;

  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';

  SecureApiClient({required this.enforceHttps, required this.apiKey, required this.secureStorage});

  String enforceHttpsUrl(String url) {
    if (enforceHttps && url.startsWith('http://')) {
      return url.replaceFirst('http://', 'https://');
    }
    return url;
  }

  Future<void> addAuthorizationHeader(RequestOptions options) async {
    final token = await getAuthToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
  }

  void addApiKeyHeader(RequestOptions options) {
    if (apiKey.isNotEmpty) {
      options.headers['X-API-Key'] = apiKey;
    }
  }

  void addSecurityHeaders(RequestOptions options) {
    options.headers['X-Frame-Options'] = 'DENY';
    options.headers['X-Content-Type-Options'] = 'nosniff';
    options.headers['X-XSS-Protection'] = '1; mode=block';

    options.headers['X-CSRF-TOKEN'] = generateCsrfToken();
  }

  String generateCsrfToken() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future<void> setAuthToken(String token) async {
    await secureStorage.write(key: _tokenKey, value: token);
  }

  Future<String?> getAuthToken() async {
    return await secureStorage.read(key: _tokenKey);
  }

  Future<void> setRefreshToken(String token) async {
    await secureStorage.write(key: _refreshTokenKey, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await secureStorage.read(key: _refreshTokenKey);
  }

  Future<void> clearTokens() async {
    await secureStorage.delete(key: _tokenKey);
    await secureStorage.delete(key: _refreshTokenKey);
  }

  dynamic sanitizeRequestData(dynamic data) {
    if (data is Map) {
      return Map.fromEntries(data.entries.map((entry) => MapEntry(entry.key, sanitizeRequestData(entry.value))));
    } else if (data is List) {
      return data.map((item) => sanitizeRequestData(item)).toList();
    } else if (data is String) {
      return data.replaceAll('<script>', '').replaceAll('</script>', '');
    }
    return data;
  }

  bool validateCertificate(X509Certificate? cert, String host, int port) {
    return true;
  }
}
