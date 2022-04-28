import 'package:taxi_line_driver/core/error.dart';
import 'package:taxi_line_driver/features/accounting/data/datasource/driver_data_source.dart';
import 'package:taxi_line_driver/features/accounting/data/model/driver_model.dart';
import 'package:taxi_line_driver/features/accounting/domain/repository/driver_repositor.dart';

class DriverRepositoryImpl implements DriverRepository {
  final DriverDataSource driverDataSource;

  DriverRepositoryImpl({
    required this.driverDataSource,
  });

  @override
  Future<DriverModel> loginUserWithEmailAndPassword(String email, String password) async {
    try{
      final driver = await driverDataSource.loginWithEmailAndPassword(email, password);
      return driver;
    }catch (exception){
      throw Error(message: exception.toString());
    }
  }

  @override
  Future<DriverModel> createUserWithEmailAndPassword(String userName, String email, String password,String carModel,String plateNumber) async {
    try{
      final driver = await driverDataSource.createUserWithEmailAndPassword(userName, email, password, carModel, plateNumber);
      return driver;
    }catch (exception){
      throw Error(message: exception.toString());
    }
  }

  @override
  Future<DriverModel> getDriverFromWithDriverId(String driverId) async {
    try {
      final driver = await driverDataSource.getDriverWithDriverId(driverId);
      return driver;
    }catch (exception){
      throw Error(message: exception.toString());
    }
  }

  @override
  Future<void> toggleDriverAvailablityInDB(DriverModel driver,bool shouldMakeAvailable) async {
    try {
      await driverDataSource.toggleDriverAvailablity(driver,shouldMakeAvailable);
      return;
    }catch (exception){
      throw Error(message: exception.toString());
    }
  }

  @override
  Future<void> changeDriverLocationInDB(double latitude, double longitude) async {
    try {
      final response = await driverDataSource.changeDriverLocation(latitude, longitude);
      return response;
    }catch (exception){
      throw Error(message: exception.toString());
    }
  }

  @override
  Future<void> updateDriver(Map<String, dynamic> updateMap) async {
    try {
      final response = await driverDataSource.updateMap(updateMap);
      return response;
    }catch (exception){
      throw Error(message: exception.toString());
    }
  }
}
