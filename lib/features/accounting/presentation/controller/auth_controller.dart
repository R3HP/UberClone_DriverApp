import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import 'package:taxi_line_driver/core/service_locator.dart';
import 'package:taxi_line_driver/features/accounting/data/model/driver_model.dart';
import 'package:taxi_line_driver/features/accounting/domain/usecase/change_driver_location_use_case.dart';
import 'package:taxi_line_driver/features/accounting/domain/usecase/create_driver_usecase.dart';
import 'package:taxi_line_driver/features/accounting/domain/usecase/get_driver_use_case.dart';
import 'package:taxi_line_driver/features/accounting/domain/usecase/login_driver_usecase.dart';
import 'package:taxi_line_driver/features/accounting/domain/usecase/make_driver_online_use_case.dart';
import 'package:taxi_line_driver/features/accounting/domain/usecase/update_driver_use_case.dart';

final authControllerProvider = ChangeNotifierProvider(((ref) => AuthController(loginUserUseCase: sl(), createUserUseCase: sl(), getDriverFromDataBase: sl(),makeDriverOnlineUseCase: sl(),changeDriverLocationUseCase: sl(),updateDriverUseCase: sl())));

class AuthController with ChangeNotifier {
  final LoginDriverUseCase loginUserUseCase;
  final CreateDriverUseCase createUserUseCase;
  final GetDriverFromDataBaseUseCase getDriverFromDataBase;
  final MakeDriverOnlineUseCase makeDriverOnlineUseCase;
  final ChangeDriverLocationUseCase changeDriverLocationUseCase;
  final UpdateDriverUseCase updateDriverUseCase;
  DriverModel? _currentDriver ;

  late LocationData _currentLocationData;

  bool isAvailable = false;


  set currentLocationData (LocationData locationData){
    _currentLocationData = locationData;
  }


  LocationData get currentLocationData {
    return _currentLocationData;
  }



  Future<void> makeAvailable(LatLng driverCurrentPosition) async {
    final response = await makeDriverOnlineUseCase(_currentDriver!);
    await changeDriverLocationInDataBase(driverCurrentPosition);
    isAvailable = true;
    notifyListeners();
    return;
  }


  Future<void> changeDriverLocationInDataBase(LatLng driverCurrentPosition) async {
    final response = await changeDriverLocationUseCase(driverCurrentPosition.latitude,driverCurrentPosition.longitude);
    return response;
  }


  AuthController({
    required this.loginUserUseCase,
    required this.createUserUseCase,
    required this.getDriverFromDataBase,
    required this.makeDriverOnlineUseCase,
    required this.changeDriverLocationUseCase,
    required this.updateDriverUseCase
  });


  DriverModel? get currentDriver{
    return _currentDriver;
  }

  set currentDriver(DriverModel? currentDriver){
    _currentDriver = currentDriver!;
  }

  Future<void> setCurrentDriver()async {
    _currentDriver = await getDriverFromDB(FirebaseAuth.instance.currentUser!.uid);
  }


  Future<DriverModel> getDriverFromDB(String driverId) async {
    final driver = await getDriverFromDataBase(driverId);
    // _currentDriver = driver;
    return driver;
  }




  Future<DriverModel> loginWithEmailAndPassword(String email,String password) async {
    final driver = await loginUserUseCase(email,password);
    _currentDriver = driver;
    return driver;
  }

  Future<DriverModel> createUser(String userName, String email, String password,String carModel,String plateNumber) async {
    final driver = await createUserUseCase(userName,email,password,carModel,plateNumber);
    _currentDriver = driver;
    return driver;
  }

  Future<void> updateDriver(Map<String,dynamic> updateMap) async {
    final response = await updateDriverUseCase(updateMap);
    final driverModel = await getDriverFromDB(_currentDriver!.id!);
    _currentDriver = driverModel;
    notifyListeners();
  }
  

}
