// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_flavor_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlavorConfig _$FlavorConfigFromJson(Map<String, dynamic> json) => FlavorConfig(
  type: $enumDecode(_$FlavorTypeEnumMap, json['type']),
  baseUrl: json['baseUrl'] as String,
  apiKey: json['apiKey'] as String,
  enableLogging: json['enableLogging'] as bool? ?? true,
  timeoutSeconds: (json['timeoutSeconds'] as num?)?.toInt() ?? 30,
  enforceHttps: json['enforceHttps'] as bool? ?? true,
  enableCertificatePinning: json['enableCertificatePinning'] as bool? ?? false,
);

Map<String, dynamic> _$FlavorConfigToJson(FlavorConfig instance) =>
    <String, dynamic>{
      'type': _$FlavorTypeEnumMap[instance.type]!,
      'baseUrl': instance.baseUrl,
      'apiKey': instance.apiKey,
      'enableLogging': instance.enableLogging,
      'timeoutSeconds': instance.timeoutSeconds,
      'enforceHttps': instance.enforceHttps,
      'enableCertificatePinning': instance.enableCertificatePinning,
    };

const _$FlavorTypeEnumMap = {
  FlavorType.dev: 'dev',
  FlavorType.staging: 'staging',
  FlavorType.prod: 'prod',
};
