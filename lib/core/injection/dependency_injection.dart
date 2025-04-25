import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:hotel_list_app/core/api/api_service.dart';
import 'package:hotel_list_app/core/flavor/base_flavor.dart';
import 'package:hotel_list_app/core/network/network_info.dart';
import 'package:hotel_list_app/features/venues/data/datasources/filter_remote_data_source.dart';
import 'package:hotel_list_app/features/venues/data/datasources/venue_remote_data_source.dart';
import 'package:hotel_list_app/features/venues/data/repositories/filter_repository_impl.dart';
import 'package:hotel_list_app/features/venues/data/repositories/venue_repository_impl.dart';
import 'package:hotel_list_app/features/venues/domain/repositories/filter_repository.dart';
import 'package:hotel_list_app/features/venues/domain/repositories/venue_repository.dart';
import 'package:hotel_list_app/core/security/secure_api_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  serviceLocator.registerLazySingleton<Connectivity>(() => Connectivity());
  serviceLocator.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());
  serviceLocator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(connectivity: serviceLocator()));

  serviceLocator.registerLazySingleton<SecureApiClient>(
    () => SecureApiClient(
      enforceHttps: BaseFlavor.enforceHttps,
      apiKey: BaseFlavor.apiKey,
      secureStorage: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<APIService>(
    () => APIService(
      baseUrl: BaseFlavor.baseUrl,
      timeoutSeconds: BaseFlavor.timeoutSeconds,
      enableLogging: BaseFlavor.enableLogging,
      secureApiClient: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<VenueRemoteDataSource>(
    () => VenueRemoteDataSourceImpl(apiService: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<FilterRemoteDataSource>(
    () => FilterRemoteDataSourceImpl(apiService: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<VenueRepository>(
    () => VenueRepositoryImpl(venueRemoteDataSource: serviceLocator(), networkInfo: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<FilterRepository>(
    () => FilterRepositoryImpl(filterRemoteDataSource: serviceLocator(), networkInfo: serviceLocator()),
  );
}
