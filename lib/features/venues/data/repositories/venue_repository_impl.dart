import 'package:hotel_list_app/core/error/exceptions.dart';
import 'package:hotel_list_app/core/error/failures.dart';
import 'package:hotel_list_app/core/network/network_info.dart';
import 'package:hotel_list_app/features/venues/data/datasources/venue_remote_data_source.dart';
import 'package:hotel_list_app/features/venues/domain/entities/venue_entity.dart';
import 'package:hotel_list_app/features/venues/domain/repositories/venue_repository.dart';

class VenueRepositoryImpl implements VenueRepository {
  final VenueRemoteDataSource venueRemoteDataSource;
  final NetworkInfo networkInfo;

  VenueRepositoryImpl({required this.venueRemoteDataSource, required this.networkInfo});

  Future<T> _safeApiCall<T>(Future<T> Function() apiCall) async {
    if (!await networkInfo.isConnected) {
      throw NetworkFailure(message: 'No internet connection');
    }

    try {
      return await apiCall();
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message, statusCode: e.statusCode);
    } on NetworkException catch (e) {
      throw NetworkFailure(message: e.message);
    } on UnknownException catch (e) {
      throw UnknownFailure(message: e.message);
    }
  }

  @override
  Future<VenueEntity> getVenueById(String id) => _safeApiCall(() async {
    final venueDTO = await venueRemoteDataSource.getVenueById(id);
    return venueDTO.toEntity();
  });

  @override
  Future<List<VenueEntity>> getVenues({
    int page = 1,
    int limit = 10,
    String category = '',
    String search = '',
    List<String> facilities = const [],
  }) => _safeApiCall(() async {
    final venueDTOs = await venueRemoteDataSource.getVenues(
      page: page,
      limit: limit,
      category: category,
      search: search,
      facilities: facilities,
    );
    return venueDTOs.map((dto) => dto.toEntity()).toList();
  });
}
