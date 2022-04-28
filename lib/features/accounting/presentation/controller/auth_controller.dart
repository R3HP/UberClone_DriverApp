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

final authControllerProvider = ChangeNotifierProvider(((ref) => AuthController(
    loginUserUseCase: sl(),
    createUserUseCase: sl(),
    getDriverFromDataBaseUseCase: sl(),
    toggleDriverOnlineUseCase: sl(),
    changeDriverLocationUseCase: sl(),
    updateDriverUseCase: sl())));

class AuthController with ChangeNotifier {
  final LoginDriverUseCase _loginUserUseCase;
  final CreateDriverUseCase _createUserUseCase;
  final GetDriverFromDataBaseUseCase _getDriverFromDataBaseUseCase;
  final ToggleDriverOnlineUseCase _toggleDriverOnlineUseCase;
  final ChangeDriverLocationUseCase _changeDriverLocationUseCase;
  final UpdateDriverUseCase _updateDriverUseCase;

  DriverModel? _currentDriver;

  late LocationData _currentLocationData;

  bool isAvailable = false;
  bool wasAvailable = false;

  AuthController(
      {required LoginDriverUseCase loginUserUseCase,
      required CreateDriverUseCase createUserUseCase,
      required GetDriverFromDataBaseUseCase getDriverFromDataBaseUseCase,
      required ToggleDriverOnlineUseCase toggleDriverOnlineUseCase,
      required ChangeDriverLocationUseCase changeDriverLocationUseCase,
      required UpdateDriverUseCase updateDriverUseCase})
      : _loginUserUseCase = loginUserUseCase,
        _createUserUseCase = createUserUseCase,
        _getDriverFromDataBaseUseCase = getDriverFromDataBaseUseCase,
        _toggleDriverOnlineUseCase = toggleDriverOnlineUseCase,
        _changeDriverLocationUseCase = changeDriverLocationUseCase,
        _updateDriverUseCase = updateDriverUseCase;

  set currentLocationData(LocationData locationData) {
    _currentLocationData = locationData;
  }

  LocationData get currentLocationData {
    return _currentLocationData;
  }

  Future<void> makeDriverOffline() async {
    await _toggleDriverOnlineUseCase(_currentDriver!, false);
    isAvailable = false;
    notifyListeners();
    return;
  }

  Future<void> makeDriverOnline(LatLng driverCurrentPosition) async {
    await _toggleDriverOnlineUseCase(_currentDriver!, true);
    await changeDriverLocationInDataBase(driverCurrentPosition);
    isAvailable = true;
    wasAvailable = true;
    notifyListeners();
    return;
  }

  Future<void> changeDriverLocationInDataBase(
      LatLng driverCurrentPosition) async {
    final response = await _changeDriverLocationUseCase(
        driverCurrentPosition.latitude, driverCurrentPosition.longitude);
    return response;
  }

  DriverModel? get currentDriver {
    return _currentDriver;
  }

  set currentDriver(DriverModel? currentDriver) {
    _currentDriver = currentDriver!;
  }

  Future<void> setCurrentDriver() async {
    _currentDriver =
        await getDriverFromDB(FirebaseAuth.instance.currentUser!.uid);
  }

  Future<DriverModel> getDriverFromDB(String driverId) async {
    final driver = await _getDriverFromDataBaseUseCase(driverId);
    return driver;
  }

  Future<DriverModel> loginWithEmailAndPassword(
      String email, String password) async {
    final driver = await _loginUserUseCase(email, password);
    _currentDriver = driver;
    return driver;
  }

  Future<DriverModel> createUser(String userName, String email, String password,
      String carModel, String plateNumber) async {
    final driver = await _createUserUseCase(
        userName, email, password, carModel, plateNumber);
    _currentDriver = driver;
    return driver;
  }

  Future<void> updateDriver(Map<String, dynamic> updateMap) async {
    await _updateDriverUseCase(updateMap);
    final driverModel = await getDriverFromDB(_currentDriver!.id!);
    _currentDriver = driverModel;
    notifyListeners();
  }
}
