import 'package:json_annotation/json_annotation.dart';
import 'package:hotel_list_app/features/venues/domain/entities/category_entity.dart';
part 'category_dto.g.dart';

@JsonSerializable()
class CategoryDto {
  final String id;
  final String name;

  CategoryDto({required this.id, required this.name});

  factory CategoryDto.fromJson(Map<String, dynamic> json) => _$CategoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryDtoToJson(this);

  CategoryEntity toEntity() => CategoryEntity(id: id, name: name);
}
