import 'package:dio/dio.dart';
import 'package:hotel_list_app/core/api/api_service.dart';
import 'package:hotel_list_app/core/error/exceptions.dart';
import 'package:hotel_list_app/features/venues/data/models/filter_dto.dart';

abstract class FilterRemoteDataSource {
  Future<List<FilterDto>> getFilters();
}

class FilterRemoteDataSourceImpl implements FilterRemoteDataSource {
  final APIService apiService;

  const FilterRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<FilterDto>> getFilters() async {
    try {
      final response = await apiService.get('/filters');

      return (response.data as List).map((json) => FilterDto.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      final isConnectionIssue = [
        DioExceptionType.connectionError,
        DioExceptionType.connectionTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.sendTimeout,
      ].contains(e.type);

      throw isConnectionIssue
          ? NetworkException(message: 'Network error: ${e.message}')
          : ServerException(message: 'Server error: ${e.message}', statusCode: e.response?.statusCode ?? 500);
    } catch (e) {
      throw UnknownException(message: 'Unknown error: $e');
    }
  }
}
