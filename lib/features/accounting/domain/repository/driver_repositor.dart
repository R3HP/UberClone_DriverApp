import 'package:taxi_line_driver/features/accounting/data/model/driver_model.dart';

abstract class DriverRepository {
  Future<DriverModel> loginUserWithEmailAndPassword(
      String email, String password);
  Future<DriverModel> createUserWithEmailAndPassword(String userName,
      String email, String password, String carModel, String plateNumber);
  Future<DriverModel> getDriverFromWithDriverId(String driverId);
  Future<void> toggleDriverAvailablityInDB(DriverModel driver,bool shouldMakeAvailable);
  Future<void> changeDriverLocationInDB(double latitude,double longitude);
  Future<void> updateDriver(Map<String,dynamic> updateMap);
}
