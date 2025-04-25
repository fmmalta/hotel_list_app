import 'package:hotel_list_app/features/venues/domain/entities/venue_entity.dart';

abstract class VenueRepository {
  Future<List<VenueEntity>> getVenues({
    int page = 1,
    int limit = 10,
    String category = '',
    String search = '',
    List<String> facilities = const [],
  });

  Future<VenueEntity> getVenueById(String id);
}
