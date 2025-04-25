import 'package:hotel_list_app/features/venues/domain/entities/filter_entity.dart';

abstract class FilterRepository {
  Future<List<FilterEntity>> getFilters();
}
