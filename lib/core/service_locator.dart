import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:taxi_line_driver/features/accounting/data/datasource/driver_data_source.dart';
import 'package:taxi_line_driver/features/accounting/data/repository/driver_repositor_impl.dart';
import 'package:taxi_line_driver/features/accounting/domain/repository/driver_repositor.dart';
import 'package:taxi_line_driver/features/accounting/domain/usecase/change_driver_location_use_case.dart';
import 'package:taxi_line_driver/features/accounting/domain/usecase/create_driver_usecase.dart';
import 'package:taxi_line_driver/features/accounting/domain/usecase/get_driver_use_case.dart';
import 'package:taxi_line_driver/features/accounting/domain/usecase/login_driver_usecase.dart';
import 'package:taxi_line_driver/features/accounting/domain/usecase/make_driver_online_use_case.dart';
import 'package:taxi_line_driver/features/accounting/domain/usecase/update_driver_use_case.dart';
import 'package:taxi_line_driver/features/cabing/data/datasource/directions_data_source.dart';
import 'package:taxi_line_driver/features/cabing/data/datasource/geo_code_data_source.dart';
import 'package:taxi_line_driver/features/cabing/data/datasource/trip_data_source.dart';
import 'package:taxi_line_driver/features/cabing/data/repository/directions_repository_impl.dart';
import 'package:taxi_line_driver/features/cabing/data/repository/geo_code_repository_impl.dart';
import 'package:taxi_line_driver/features/cabing/data/repository/trip_repository_impl.dart';
import 'package:taxi_line_driver/features/cabing/domain/repository/directions_repository.dart';
import 'package:taxi_line_driver/features/cabing/domain/repository/geo_code_repository.dart';
import 'package:taxi_line_driver/features/cabing/domain/repository/trip_repository.dart';
import 'package:taxi_line_driver/features/cabing/domain/usecase/finish_pending_trip_use_case.dart';
import 'package:taxi_line_driver/features/cabing/domain/usecase/geo_code_address_to_latlng.dart';
import 'package:taxi_line_driver/features/cabing/domain/usecase/geo_code_latlng_to_address.dart';
import 'package:taxi_line_driver/features/cabing/domain/usecase/get_directions_use_case.dart';
import 'package:taxi_line_driver/features/cabing/domain/usecase/get_trip_requests_use_case.dart';
import 'package:taxi_line_driver/features/cabing/domain/usecase/select_trip_use_case.dart';
import 'package:taxi_line_driver/features/cabing/presentation/controller/directions_controller.dart';
import 'package:taxi_line_driver/features/cabing/presentation/controller/geo_code_controller.dart';
import 'package:taxi_line_driver/features/cabing/presentation/controller/trip_controller.dart';

final sl = GetIt.instance;


setUp(){
  registerAccounting();
  registerCabbing();
  registerDirecting();
  registerTripping();
  sl.registerLazySingleton<Dio>(() => Dio());
}

void registerTripping() {
  
  // controller
  sl.registerLazySingleton<TripController>(() => TripController(getTripRequestsUseCase: sl(),selectTripUseCase: sl(), finishPendingTripUseCase: sl()));
  
  // usecase
  sl.registerLazySingleton<FinishPendingTripUseCase>(() => FinishPendingTripUseCase(tripRepository: sl()));
  sl.registerLazySingleton<GetTripRequestsUseCase>(() => GetTripRequestsUseCase(tripRepository: sl()));
  sl.registerLazySingleton<SelectTripUseCase>(() => SelectTripUseCase(tripRepository: sl()));
  // sl.registerLazySingleton<DeleteTripRequestUseCase>(() => DeleteTripRequestUseCase(tripRepository: sl()));
  // sl.registerLazySingleton<UpdateTripUseCase>(() => UpdateTripUseCase(tripRepository: sl()));
  
  // repository
  sl.registerLazySingleton<TripRepository>(() => TripRepositoryImpl(tripDataSource: sl()));
  
  // data source
  sl.registerLazySingleton<TripDataSource>(() => TripDataSourceImpl());
}

void registerDirecting() {
  
  // controller 
  sl.registerLazySingleton<DirectionsController>(() => DirectionsController(getDirectionsUseCase: sl()));
  // usecase
  sl.registerLazySingleton<GetDirectionsUseCase>(() => GetDirectionsUseCase(directionRepository: sl()));
  // repository
  sl.registerLazySingleton<DirectionsRepository>(() => DirectionsRepositoryImpl(directionDataSource: sl()));
  // dataSouce
  sl.registerLazySingleton<DirectionsDataSource>(() => DirectionsDataSourceImpl(dio: sl()));
}

void registerCabbing() {
  
  // controller 
  sl.registerLazySingleton<GeoCodeController>(() => GeoCodeController(addressToLatLngUseCase: sl(), latLngToAddressUseCase: sl()));
  // usecases
  sl.registerLazySingleton<GeoCodingAddressToLatLngUseCase>(() => GeoCodingAddressToLatLngUseCase(geoCodingRepostory: sl()));
  sl.registerLazySingleton<GeoCodingLatLngToAddressUseCase>(() => GeoCodingLatLngToAddressUseCase(geoCodingRepository: sl()));
  
  // repository
  sl.registerLazySingleton<GeoCodingRepository>(() => GeoCodingRepositoryImpl(dataSource: sl()));
  
  // datasource
  sl.registerLazySingleton<GeoCodingDataSource>(() => GeoCodingDataSourceImpl(dio: sl()));
}

void registerAccounting() {
  
  // controller 
  
  // sl.registerLazySingleton<AuthController>(() => AuthController(loginUserUseCase: sl(), createUserUseCase: sl()));
  
  // // usecases
  sl.registerLazySingleton<LoginDriverUseCase>(() => LoginDriverUseCase(driverRepository: sl()));
  sl.registerLazySingleton<CreateDriverUseCase>(() => CreateDriverUseCase(driverRepository: sl()));
  sl.registerLazySingleton<GetDriverFromDataBaseUseCase>(() => GetDriverFromDataBaseUseCase(driverRepository: sl()));
  sl.registerLazySingleton<ToggleDriverOnlineUseCase>(() => ToggleDriverOnlineUseCase(driverRepository: sl()));
  sl.registerLazySingleton<ChangeDriverLocationUseCase>(() => ChangeDriverLocationUseCase(driverRepository: sl()));
  sl.registerLazySingleton<UpdateDriverUseCase>(() => UpdateDriverUseCase(driverRepository: sl()));
  
  // // repository 
  sl.registerLazySingleton<DriverRepository>(() => DriverRepositoryImpl(driverDataSource: sl()));
  
  // // datasource
  sl.registerLazySingleton<DriverDataSource>(() => DriverDataSourceImpl());
}