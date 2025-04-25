import 'package:dio/dio.dart';
import 'package:hotel_list_app/core/api/api_service.dart';
import 'package:hotel_list_app/core/error/exceptions.dart';
import 'package:hotel_list_app/features/venues/data/models/filter_dto.dart';

abstract class FilterRemoteDataSource {
  Future<List<FilterDto>> getFilters();
}

class FilterRemoteDataSourceImpl implements FilterRemoteDataSource {
  final APIService apiService;

  FilterRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<FilterDto>> getFilters() async {
    try {
      final response = await apiService.get('/filters');

      final List<dynamic> filtersJson = response.data as List<dynamic>;
      return filtersJson.map((json) => FilterDto.fromJson(json as Map<String, dynamic>)).toList();
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
