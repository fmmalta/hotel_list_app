import 'package:dio/dio.dart';
import 'package:hotel_list_app/core/api/api_service.dart';
import 'package:hotel_list_app/core/error/exceptions.dart';
import 'package:hotel_list_app/features/venues/data/models/venue_dto.dart';

abstract class VenueRemoteDataSource {
  Future<List<VenueDTO>> getVenues({
    int page = 1,
    int limit = 10,
    String category = '',
    String search = '',
    List<String> facilities = const [],
  });
  Future<VenueDTO> getVenueById(String id);
}

class VenueRemoteDataSourceImpl implements VenueRemoteDataSource {
  final APIService apiService;

  VenueRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<VenueDTO>> getVenues({
    int page = 1,
    int limit = 10,
    String category = '',
    String search = '',
    List<String> facilities = const [],
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'limit': limit};

      if (category.isNotEmpty) {
        queryParams['category'] = category;
      }

      if (search.isNotEmpty) {
        queryParams['search'] = search;
      }

      if (facilities.isNotEmpty) {
        queryParams['facilities'] = facilities.join(',');
      }

      final response = await apiService.get('/venues', queryParameters: queryParams);

      final List<dynamic> venuesJson = response.data as List<dynamic>;
      return venuesJson.map((json) => VenueDTO.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException(message: 'Network error: ${e.message}');
      }
      throw ServerException(message: 'Server error: ${e.message}', statusCode: e.response?.statusCode ?? 500);
    } catch (e) {
      throw UnknownException(message: 'Unknown error: $e');
    }
  }

  @override
  Future<VenueDTO> getVenueById(String id) async {
    try {
      final response = await apiService.get('/venues/$id');

      return VenueDTO.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException(message: 'Network error: ${e.message}');
      }
      throw ServerException(message: 'Server error: ${e.message}', statusCode: e.response?.statusCode ?? 500);
    } catch (e) {
      throw UnknownException(message: 'Unknown error: $e');
    }
  }
}
