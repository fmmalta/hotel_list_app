import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hotel_list_app/core/api/api_service.dart';
import 'package:hotel_list_app/core/error/exceptions.dart';
import 'package:hotel_list_app/features/venues/data/datasources/filter_remote_data_source.dart';
import 'package:hotel_list_app/features/venues/data/models/filter_dto.dart';

import 'filter_remote_data_source_test.mocks.dart';

@GenerateMocks([APIService])
void main() {
  late MockAPIService mockApiService;
  late FilterRemoteDataSourceImpl dataSource;

  setUp(() {
    mockApiService = MockAPIService();
    dataSource = FilterRemoteDataSourceImpl(apiService: mockApiService);
  });

  group('getFilters', () {
    final tFiltersResponse = [
      {
        'id': '1',
        'name': 'Category',
        'type': 'category',
        'categories': [
          {'id': '1', 'name': 'Hotels', 'slug': 'hotels'},
        ],
      },
      {
        'id': '2',
        'name': 'Price',
        'type': 'price',
        'categories': [
          {'id': '2', 'name': 'Low', 'slug': 'low'},
          {'id': '3', 'name': 'Medium', 'slug': 'medium'},
          {'id': '4', 'name': 'High', 'slug': 'high'},
        ],
      },
    ];

    test('should return List<FilterDto> when API call is successful', () async {
      // arrange
      when(mockApiService.get('/filters')).thenAnswer(
        (_) async =>
            Response(data: tFiltersResponse, statusCode: 200, requestOptions: RequestOptions(path: '/filters')),
      );

      // act
      final result = await dataSource.getFilters();

      // assert
      expect(result, isA<List<FilterDto>>());
      expect(result.length, 2);
      expect(result.first.name, 'Category');
      expect(result.first.categories.length, 1);
      expect(result.first.categories.first.name, 'Hotels');
      expect(result[1].categories.length, 3);
      verify(mockApiService.get('/filters'));
    });

    test('should throw UnknownException when response code is not 200', () async {
      // arrange
      when(mockApiService.get('/filters')).thenAnswer(
        (_) async =>
            Response(data: {'message': 'Error'}, statusCode: 404, requestOptions: RequestOptions(path: '/filters')),
      );

      // act and assert
      expect(() async => await dataSource.getFilters(), throwsA(isA<UnknownException>()));
    });

    test('should throw NetworkException when DioException is of connection type', () async {
      // arrange
      when(mockApiService.get('/filters')).thenThrow(
        DioException(
          type: DioExceptionType.connectionError,
          error: 'Connection error',
          requestOptions: RequestOptions(path: '/filters'),
        ),
      );

      // act
      final call = dataSource.getFilters;

      // assert
      expect(() => call(), throwsA(isA<NetworkException>()));
    });

    test('should throw ServerException when server returns an error', () async {
      // arrange
      when(mockApiService.get('/filters')).thenThrow(
        DioException(
          type: DioExceptionType.badResponse,
          response: Response(statusCode: 500, requestOptions: RequestOptions(path: '/filters')),
          requestOptions: RequestOptions(path: '/filters'),
        ),
      );

      // act
      final call = dataSource.getFilters;

      // assert
      expect(() => call(), throwsA(isA<ServerException>()));
    });
  });
}
