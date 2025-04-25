import 'package:hotel_list_app/features/venues/domain/entities/filter_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'category_dto.dart';

part 'filter_dto.g.dart';

@JsonSerializable()
class FilterDto {
  final String id;
  final String name;
  final String type;
  @JsonKey(name: 'categories')
  final List<CategoryDto> categories;

  FilterDto({required this.id, required this.name, required this.type, required this.categories});

  factory FilterDto.fromJson(Map<String, dynamic> json) => _$FilterDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FilterDtoToJson(this);

  FilterEntity toEntity() => FilterEntity(
    id: id,
    name: name,
    type: type,
    categories: categories.map((category) => category.toEntity()).toList(),
  );
}
