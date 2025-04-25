import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hotel_list_app/core/error/exceptions.dart';
import 'package:hotel_list_app/core/error/failures.dart';
import 'package:hotel_list_app/core/network/network_info.dart';
import 'package:hotel_list_app/features/venues/data/datasources/venue_remote_data_source.dart';
import 'package:hotel_list_app/features/venues/data/models/venue_dto.dart';
import 'package:hotel_list_app/features/venues/data/repositories/venue_repository_impl.dart';

import 'venue_repository_impl_test.mocks.dart';

@GenerateMocks([VenueRemoteDataSource, NetworkInfo])
void main() {
  late MockVenueRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late VenueRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockVenueRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = VenueRepositoryImpl(venueRemoteDataSource: mockRemoteDataSource, networkInfo: mockNetworkInfo);
  });

  final tVenueDTO = VenueDTO(
    id: '1',
    name: 'Test Venue',
    location: 'Test Location',
    overview: 'Test Overview',
    rating: 4.5,
    price: 100.0,
    coordinates: CoordinatesDTO(latitude: 1.0, longitude: 1.0),
    createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
    images: [ImageDTO(id: '1', url: 'https://example.com/image.jpg', venueId: '1')],
    activities: [ActivityDTO(id: '1', name: 'Swimming')],
    facilities: [FacilityDTO(id: '1', name: 'WiFi')],
    thingsToDo: [
      ThingToDoDTO(
        id: '1',
        title: 'Thing To Do',
        badge: 'Badge',
        subtitle: 'Subtitle',
        content: 'Content',
        venueId: '1',
      ),
    ],
  );

  final tVenueDTOList = [tVenueDTO];
  final tVenueEntity = tVenueDTO.toEntity();
  final tVenueEntityList = tVenueDTOList.map((dto) => dto.toEntity()).toList();

  group('getVenueById', () {
    const tId = '1';

    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getVenueById(tId)).thenAnswer((_) async => tVenueDTO);
      // act
      await repository.getVenueById(tId);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should return VenueEntity when the call to remote data source is successful', () async {
        // arrange
        when(mockRemoteDataSource.getVenueById(tId)).thenAnswer((_) async => tVenueDTO);
        // act
        final result = await repository.getVenueById(tId);
        // assert
        expect(result, equals(tVenueEntity));
        verify(mockRemoteDataSource.getVenueById(tId));
      });

      test('should throw ServerFailure when the call to remote data source is unsuccessful', () async {
        // arrange
        when(
          mockRemoteDataSource.getVenueById(tId),
        ).thenThrow(ServerException(message: 'Server error', statusCode: 500));
        // act
        final call = repository.getVenueById;
        // assert
        expect(() => call(tId), throwsA(isA<ServerFailure>()));
      });

      test('should throw NetworkFailure when there is network issue', () async {
        // arrange
        when(mockRemoteDataSource.getVenueById(tId)).thenThrow(NetworkException(message: 'Network error'));
        // act
        final call = repository.getVenueById;
        // assert
        expect(() => call(tId), throwsA(isA<NetworkFailure>()));
      });

      test('should throw UnknownFailure when an unknown error occurs', () async {
        // arrange
        when(mockRemoteDataSource.getVenueById(tId)).thenThrow(UnknownException(message: 'Unknown error'));
        // act
        final call = repository.getVenueById;
        // assert
        expect(() => call(tId), throwsA(isA<UnknownFailure>()));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should throw NetworkFailure when device is offline', () async {
        // act
        final call = repository.getVenueById;
        // assert
        expect(() => call(tId), throwsA(isA<NetworkFailure>()));
        verifyZeroInteractions(mockRemoteDataSource);
      });
    });
  });

  group('getVenues', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getVenues(page: 1, limit: 10, category: '')).thenAnswer((_) async => tVenueDTOList);
      // act
      await repository.getVenues();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should return a list of VenueEntity when the call to remote data source is successful', () async {
        // arrange
        when(mockRemoteDataSource.getVenues(page: 1, limit: 10, category: '')).thenAnswer((_) async => tVenueDTOList);
        // act
        final result = await repository.getVenues();
        // assert
        expect(result, equals(tVenueEntityList));
        verify(mockRemoteDataSource.getVenues(page: 1, limit: 10, category: ''));
      });

      test('should use the category parameter when provided', () async {
        // arrange
        when(
          mockRemoteDataSource.getVenues(page: 1, limit: 10, category: 'hotels'),
        ).thenAnswer((_) async => tVenueDTOList);
        // act
        await repository.getVenues(category: 'hotels');
        // assert
        verify(mockRemoteDataSource.getVenues(page: 1, limit: 10, category: 'hotels'));
      });

      test('should throw ServerFailure when the call to remote data source is unsuccessful', () async {
        // arrange
        when(
          mockRemoteDataSource.getVenues(page: 1, limit: 10, category: ''),
        ).thenThrow(ServerException(message: 'Server error', statusCode: 500));
        // act
        final call = repository.getVenues;
        // assert
        expect(() => call(), throwsA(isA<ServerFailure>()));
      });

      test('should throw NetworkFailure when there is network issue', () async {
        // arrange
        when(
          mockRemoteDataSource.getVenues(page: 1, limit: 10, category: ''),
        ).thenThrow(NetworkException(message: 'Network error'));
        // act
        final call = repository.getVenues;
        // assert
        expect(() => call(), throwsA(isA<NetworkFailure>()));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should throw NetworkFailure when device is offline', () async {
        // act
        final call = repository.getVenues;
        // assert
        expect(() => call(), throwsA(isA<NetworkFailure>()));
        verifyZeroInteractions(mockRemoteDataSource);
      });
    });
  });
}
