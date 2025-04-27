import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_annotation/json_annotation.dart';

part 'base_flavor_config.g.dart';

enum FlavorType { dev, staging, prod }

@JsonSerializable()
class FlavorConfig {
  final FlavorType type;
  final String baseUrl;
  final String apiKey;
  final bool enableLogging;
  final int timeoutSeconds;
  final bool enforceHttps;
  final bool enableCertificatePinning;

  const FlavorConfig({
    required this.type,
    required this.baseUrl,
    required this.apiKey,
    this.enableLogging = true,
    this.timeoutSeconds = 30,
    this.enforceHttps = true,
    this.enableCertificatePinning = false,
  });

  factory FlavorConfig.fromJson(Map<String, dynamic> json) => _$FlavorConfigFromJson(json);

  Map<String, dynamic> toJson() => _$FlavorConfigToJson(this);

  factory FlavorConfig.fromType(FlavorType type) {
    switch (type) {
      case FlavorType.dev:
        return FlavorConfig(
          type: type,
          baseUrl: dotenv.env['BASE_URL'] ?? '',
          apiKey: dotenv.env['API_KEY'] ?? '',
          enableLogging: true,
          timeoutSeconds: 60,
          enforceHttps: false,
          enableCertificatePinning: false,
        );
      case FlavorType.staging:
        return FlavorConfig(
          type: type,
          baseUrl: 'https://staging-api.example.com',
          apiKey: dotenv.env['STAGING_API_KEY'] ?? '',
          enableLogging: true,
          timeoutSeconds: 45,
          enforceHttps: true,
          enableCertificatePinning: false,
        );
      case FlavorType.prod:
        return FlavorConfig(
          type: type,
          baseUrl: 'https://api.example.com',
          apiKey: dotenv.env['PROD_API_KEY'] ?? '',
          enableLogging: false,
          timeoutSeconds: 30,
          enforceHttps: true,
          enableCertificatePinning: true,
        );
    }
  }

  FlavorConfig copyWith({
    FlavorType? type,
    String? baseUrl,
    String? apiKey,
    bool? enableLogging,
    int? timeoutSeconds,
    bool? enforceHttps,
    bool? enableCertificatePinning,
  }) {
    return FlavorConfig(
      type: type ?? this.type,
      baseUrl: baseUrl ?? this.baseUrl,
      apiKey: apiKey ?? this.apiKey,
      enableLogging: enableLogging ?? this.enableLogging,
      timeoutSeconds: timeoutSeconds ?? this.timeoutSeconds,
      enforceHttps: enforceHttps ?? this.enforceHttps,
      enableCertificatePinning: enableCertificatePinning ?? this.enableCertificatePinning,
    );
  }
}
