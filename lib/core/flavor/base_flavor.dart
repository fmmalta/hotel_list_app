import 'package:hotel_list_app/core/flavor/base_flavor_config.dart';

class BaseFlavor {
  static FlavorType? _flavor;
  static FlavorConfig? _config;

  static void initialize(FlavorType flavor) {
    _flavor = flavor;
    _config = FlavorConfig.fromType(flavor);
  }

  static FlavorType get flavor => _flavor ?? FlavorType.dev;
  static FlavorConfig get config => _config ?? FlavorConfig.fromType(flavor);

  static bool get isDev => flavor == FlavorType.dev;
  static bool get isStaging => flavor == FlavorType.staging;
  static bool get isProd => flavor == FlavorType.prod;

  static String get name => flavor.name;
  static String get baseUrl => config.baseUrl;
  static String get apiKey => config.apiKey;
  static bool get enableLogging => config.enableLogging;
  static int get timeoutSeconds => config.timeoutSeconds;
  static bool get enforceHttps => config.enforceHttps;
  static bool get enableCertificatePinning => config.enableCertificatePinning;

  @override
  String toString() => 'Flavor: $name, URL: $baseUrl';
}
