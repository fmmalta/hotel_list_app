import 'package:hotel_list_app/core/error/exceptions.dart';
import 'package:hotel_list_app/core/error/failures.dart';
import 'package:hotel_list_app/core/network/network_info.dart';
import 'package:hotel_list_app/features/venues/data/datasources/filter_remote_data_source.dart';
import 'package:hotel_list_app/features/venues/domain/entities/filter_entity.dart';
import 'package:hotel_list_app/features/venues/domain/repositories/filter_repository.dart';

class FilterRepositoryImpl implements FilterRepository {
  final FilterRemoteDataSource filterRemoteDataSource;
  final NetworkInfo networkInfo;

  FilterRepositoryImpl({required this.filterRemoteDataSource, required this.networkInfo});

  @override
  Future<List<FilterEntity>> getFilters() async {
    if (await networkInfo.isConnected) {
      try {
        final filters = await filterRemoteDataSource.getFilters();
        return filters.map((filter) => filter.toEntity()).toList();
      } on ServerException catch (e) {
        throw ServerFailure(message: e.message, statusCode: e.statusCode);
      } on NetworkException catch (e) {
        throw NetworkFailure(message: e.message);
      } on UnknownException catch (e) {
        throw UnknownFailure(message: e.message);
      }
    } else {
      throw NetworkFailure(message: 'No internet connection');
    }
  }
}
