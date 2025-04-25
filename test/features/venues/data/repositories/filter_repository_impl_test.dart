import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hotel_list_app/core/error/exceptions.dart';
import 'package:hotel_list_app/core/error/failures.dart';
import 'package:hotel_list_app/core/network/network_info.dart';
import 'package:hotel_list_app/features/venues/data/datasources/filter_remote_data_source.dart';
import 'package:hotel_list_app/features/venues/data/models/category_dto.dart';
import 'package:hotel_list_app/features/venues/data/models/filter_dto.dart';
import 'package:hotel_list_app/features/venues/data/repositories/filter_repository_impl.dart';

import 'filter_repository_impl_test.mocks.dart';

@GenerateMocks([FilterRemoteDataSource, NetworkInfo])
void main() {
  late MockFilterRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late FilterRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockFilterRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = FilterRepositoryImpl(filterRemoteDataSource: mockRemoteDataSource, networkInfo: mockNetworkInfo);
  });

  final tCategoryDto = CategoryDto(id: '1', name: 'Hotels');
  final tFilterDto = FilterDto(id: '1', name: 'Category', type: 'category', categories: [tCategoryDto]);
  final tFilterDtoList = [tFilterDto];
  final tFilterEntityList = tFilterDtoList.map((dto) => dto.toEntity()).toList();

  group('getFilters', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getFilters()).thenAnswer((_) async => tFilterDtoList);
      // act
      await repository.getFilters();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should return a list of FilterEntity when the call to remote data source is successful', () async {
        // arrange
        when(mockRemoteDataSource.getFilters()).thenAnswer((_) async => tFilterDtoList);
        // act
        final result = await repository.getFilters();
        // assert
        expect(result.length, equals(tFilterEntityList.length));
        expect(result.first.id, equals(tFilterEntityList.first.id));
        expect(result.first.name, equals(tFilterEntityList.first.name));
        expect(result.first.type, equals(tFilterEntityList.first.type));
        expect(result.first.categories.length, equals(tFilterEntityList.first.categories.length));
        verify(mockRemoteDataSource.getFilters());
      });

      test('should throw ServerFailure when the call to remote data source is unsuccessful', () async {
        // arrange
        when(mockRemoteDataSource.getFilters()).thenThrow(ServerException(message: 'Server error', statusCode: 500));
        // act
        final call = repository.getFilters;
        // assert
        expect(() => call(), throwsA(isA<ServerFailure>()));
      });

      test('should throw NetworkFailure when there is network issue', () async {
        // arrange
        when(mockRemoteDataSource.getFilters()).thenThrow(NetworkException(message: 'Network error'));
        // act
        final call = repository.getFilters;
        // assert
        expect(() => call(), throwsA(isA<NetworkFailure>()));
      });

      test('should throw UnknownFailure when an unknown error occurs', () async {
        // arrange
        when(mockRemoteDataSource.getFilters()).thenThrow(UnknownException(message: 'Unknown error'));
        // act
        final call = repository.getFilters;
        // assert
        expect(() => call(), throwsA(isA<UnknownFailure>()));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should throw NetworkFailure when device is offline', () async {
        // act
        final call = repository.getFilters;
        // assert
        expect(() => call(), throwsA(isA<NetworkFailure>()));
        verifyZeroInteractions(mockRemoteDataSource);
      });
    });
  });
}
