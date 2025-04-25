// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterDto _$FilterDtoFromJson(Map<String, dynamic> json) => FilterDto(
  id: json['id'] as String,
  name: json['name'] as String,
  type: json['type'] as String,
  categories:
      (json['categories'] as List<dynamic>)
          .map((e) => CategoryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$FilterDtoToJson(FilterDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': instance.type,
  'categories': instance.categories,
};
