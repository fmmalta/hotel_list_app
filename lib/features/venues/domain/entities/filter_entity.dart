import 'category_entity.dart';

class FilterEntity {
  final String id;
  final String name;
  final String type;
  final List<CategoryEntity> categories;

  FilterEntity({required this.id, required this.name, required this.type, required this.categories});
}
