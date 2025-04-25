import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hotel_list_app/core/api/api_service.dart';
import 'package:hotel_list_app/core/error/exceptions.dart';
import 'package:hotel_list_app/features/venues/data/datasources/venue_remote_data_source.dart';
import 'package:hotel_list_app/features/venues/data/models/venue_dto.dart';

import 'venue_remote_data_source_test.mocks.dart';

@GenerateMocks([APIService])
void main() {
  late MockAPIService mockApiService;
  late VenueRemoteDataSourceImpl dataSource;

  setUp(() {
    mockApiService = MockAPIService();
    dataSource = VenueRemoteDataSourceImpl(apiService: mockApiService);
  });

  group('getVenues', () {
    final tVenuesResponse = [
      {
        'id': '1',
        'name': 'Test Venue',
        'location': 'Test Location',
        'overview': 'Test Overview',
        'rating': 4.5,
        'price': 100.0,
        'createdAt': '2023-01-01T00:00:00.000Z',
        'images': [
          {'id': '1', 'url': 'https://example.com/image.jpg', 'venueId': '1'},
        ],
        'activities': [
          {'id': '1', 'name': 'Swimming'},
        ],
        'facilities': [
          {'id': '1', 'name': 'WiFi'},
        ],
      },
    ];

    test('should return List<VenueDTO> when API call is successful', () async {
      // arrange
      when(mockApiService.get('/venues', queryParameters: {'page': 1, 'limit': 10})).thenAnswer(
        (_) async => Response(data: tVenuesResponse, statusCode: 200, requestOptions: RequestOptions(path: '/venues')),
      );

      // act
      final result = await dataSource.getVenues();

      // assert
      expect(result, isA<List<VenueDTO>>());
      expect(result.length, 1);
      expect(result.first.name, 'Test Venue');
      verify(mockApiService.get('/venues', queryParameters: {'page': 1, 'limit': 10}));
    });

    test('should include category parameter when provided', () async {
      // arrange
      when(mockApiService.get('/venues', queryParameters: {'page': 1, 'limit': 10, 'category': 'hotels'})).thenAnswer(
        (_) async => Response(data: tVenuesResponse, statusCode: 200, requestOptions: RequestOptions(path: '/venues')),
      );

      // act
      await dataSource.getVenues(category: 'hotels');

      // assert
      verify(mockApiService.get('/venues', queryParameters: {'page': 1, 'limit': 10, 'category': 'hotels'}));
    });

    test('should throw UnknownException when response code is not 200', () async {
      // arrange
      when(mockApiService.get('/venues', queryParameters: {'page': 1, 'limit': 10})).thenAnswer(
        (_) async =>
            Response(data: {'message': 'Error'}, statusCode: 404, requestOptions: RequestOptions(path: '/venues')),
      );

      // act and assert
      expect(() async => await dataSource.getVenues(), throwsA(isA<UnknownException>()));
    });

    test('should throw NetworkException when DioException is of connection type', () async {
      // arrange
      when(mockApiService.get('/venues', queryParameters: {'page': 1, 'limit': 10})).thenThrow(
        DioException(
          type: DioExceptionType.connectionError,
          error: 'Connection error',
          requestOptions: RequestOptions(path: '/venues'),
        ),
      );

      // act
      final call = dataSource.getVenues;

      // assert
      expect(() => call(), throwsA(isA<NetworkException>()));
    });

    test('should throw ServerException with 404 when API returns 404', () async {
      // arrange
      when(mockApiService.get('/venues', queryParameters: {'page': 1, 'limit': 10})).thenThrow(
        DioException(
          type: DioExceptionType.badResponse,
          response: Response(statusCode: 404, requestOptions: RequestOptions(path: '/venues')),
          requestOptions: RequestOptions(path: '/venues'),
        ),
      );

      // act
      final call = dataSource.getVenues;

      // assert
      expect(() => call(), throwsA(isA<ServerException>()));
    });
  });

  group('getVenueById', () {
    final tVenueResponse = {
      'id': '1',
      'name': 'Test Venue',
      'location': 'Test Location',
      'overview': 'Test Overview',
      'rating': 4.5,
      'price': 100.0,
      'createdAt': '2023-01-01T00:00:00.000Z',
      'images': [
        {'id': '1', 'url': 'https://example.com/image.jpg', 'venueId': '1'},
      ],
      'activities': [
        {'id': '1', 'name': 'Swimming'},
      ],
      'facilities': [
        {'id': '1', 'name': 'WiFi'},
      ],
    };

    test('should return VenueDTO when API call is successful', () async {
      // arrange
      when(mockApiService.get('/venues/1')).thenAnswer(
        (_) async => Response(data: tVenueResponse, statusCode: 200, requestOptions: RequestOptions(path: '/venues/1')),
      );

      // act
      final result = await dataSource.getVenueById('1');

      // assert
      expect(result, isA<VenueDTO>());
      expect(result.id, '1');
      expect(result.name, 'Test Venue');
      verify(mockApiService.get('/venues/1'));
    });

    test('should throw UnknownException when response code is not 200', () async {
      // arrange
      when(mockApiService.get('/venues/1')).thenAnswer(
        (_) async =>
            Response(data: {'message': 'Error'}, statusCode: 404, requestOptions: RequestOptions(path: '/venues/1')),
      );

      // act and assert
      expect(() async => await dataSource.getVenueById('1'), throwsA(isA<UnknownException>()));
    });

    test('should throw NetworkException when DioException is of connection type', () async {
      // arrange
      when(mockApiService.get('/venues/1')).thenThrow(
        DioException(
          type: DioExceptionType.connectionError,
          error: 'Connection error',
          requestOptions: RequestOptions(path: '/venues/1'),
        ),
      );

      // act
      final call = dataSource.getVenueById;

      // assert
      expect(() => call('1'), throwsA(isA<NetworkException>()));
    });

    test('should throw ServerException with 404 when venue not found', () async {
      // arrange
      when(mockApiService.get('/venues/1')).thenThrow(
        DioException(
          type: DioExceptionType.badResponse,
          response: Response(statusCode: 404, requestOptions: RequestOptions(path: '/venues/1')),
          requestOptions: RequestOptions(path: '/venues/1'),
        ),
      );

      // act
      final call = dataSource.getVenueById;

      // assert
      expect(() => call('1'), throwsA(isA<ServerException>()));
    });
  });
}
