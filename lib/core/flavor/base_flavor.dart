import 'package:flutter_dotenv/flutter_dotenv.dart';

enum FlavorType { dev, staging, prod }

class BaseFlavor {
  static FlavorType? _flavor;

  static void initialize(FlavorType flavor) {
    _flavor = flavor;
  }

  static FlavorType get flavor => _flavor ?? FlavorType.dev;

  static bool get isDev => flavor == FlavorType.dev;
  static bool get isStaging => flavor == FlavorType.staging;
  static bool get isProd => flavor == FlavorType.prod;

  static String get name => flavor.name;

  static String get baseUrl {
    final baseUrl = dotenv.env['BASE_URL'];
    switch (flavor) {
      case FlavorType.dev:
        return baseUrl ?? '';
      case FlavorType.staging:
        return 'https://staging-api.example.com';
      case FlavorType.prod:
        return 'https://api.example.com';
    }
  }

  static String get apiKey {
    final apiKey = dotenv.env['API_KEY'];
    switch (flavor) {
      case FlavorType.dev:
        return apiKey ?? '';
      case FlavorType.staging:
        return dotenv.env['STAGING_API_KEY'] ?? '';
      case FlavorType.prod:
        return dotenv.env['PROD_API_KEY'] ?? '';
    }
  }

  static bool get enableLogging => !isProd;
  static int get timeoutSeconds => isProd ? 30 : 60;

  static bool get enforceHttps => isProd || isStaging;
  static bool get enableCertificatePinning => isProd;

  @override
  String toString() => 'Flavor: $name, URL: $baseUrl';
}
