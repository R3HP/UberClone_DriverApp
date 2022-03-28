import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:taxi_line_driver/features/accounting/data/model/driver_model.dart';

abstract class DriverDataSource {
  Future<DriverModel> loginWithEmailAndPassword(String email, String password);
  Future<DriverModel> createUserWithEmailAndPassword(String userName,
      String email, String password, String carModel, String plateNumber);
  Future<DriverModel> getDriverWithDriverId(String driverId);
  Future<void> makeDriverAvailable(DriverModel driver);
  Future<void> changeDriverLocation(double latitude,double longitude);
  Future<void> updateMap(Map<String,dynamic> updateMap);
}

class DriverDataSourceImpl implements DriverDataSource {
  @override
  Future<DriverModel> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      final credentials = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final dbRef =
          FirebaseDatabase.instance.ref('drivers').child(credentials.user!.uid);
      final userDataSnapShot = await dbRef.get();
      // final driver = DriverModel.fromMap(userDataSnapShot.value);
      // turning Internal Hash Map to Map
      final driverMap = Map<String, dynamic>.fromIterables(
          userDataSnapShot.children.map((snap) => snap.key!),
          userDataSnapShot.children.map((snap) => snap.value));
      final driver = DriverModel.fromMap(driverMap);
      return driver;
    } catch (error) {
      print(error);
      throw UnimplementedError();
    }
  }

  @override
  Future<DriverModel> createUserWithEmailAndPassword(
      String userName,
      String email,
      String password,
      String carModel,
      String plateNumber) async {
    try {
      final credentials = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final dbRef =
          FirebaseDatabase.instance.ref('drivers').child(credentials.user!.uid);
      final driver = DriverModel(
          userName: userName,
          profilePictureUrl: '',
          credit: 0,
          carModel: carModel,
          plateNumber: plateNumber,
          id: dbRef.key);
      print(driver.toMap());
      await dbRef.set(driver.toMap());
      return driver;
    } catch (error) {
      print(error.toString());
      throw UnimplementedError();
    }
  }

  @override
  Future<DriverModel> getDriverWithDriverId(String driverId) async {
    try {
      final dbRef =
          FirebaseDatabase.instance.ref().child('drivers').child(driverId);
      final response = await dbRef.get();
      final driverMap = Map<String, dynamic>.fromIterables(
          response.children.map((snap) => snap.key!),
          response.children.map((snap) => snap.value));
      final driver = DriverModel.fromMap(driverMap);
      return driver;
    } catch (error) {
      throw UnimplementedError();
    }
  }

  @override
  Future<void> makeDriverAvailable(DriverModel driver) async {
    try {
      final dbRef = FirebaseDatabase.instance
          .ref()
          .child('availableDrivers')
          .child(driver.id!);
      final response = await dbRef.set(driver.toMap());
      return ;
    } catch (error) {
      throw UnimplementedError();
    }
  }

  @override
  Future<void> changeDriverLocation(double latitude, double longitude) async {
    try {
      final dbRef = FirebaseDatabase.instance.ref().child('availableDrivers').child(FirebaseAuth.instance.currentUser!.uid).child('location');
      final response = await dbRef.set({'latitude': latitude,'longitude': longitude});
    } catch (error) {
      throw UnimplementedError();
    }
  }

  @override
  Future<void> updateMap(Map<String, dynamic> updateMap) async {
    final dbRef = FirebaseDatabase.instance.ref().child('drivers').child(FirebaseAuth.instance.currentUser!.uid);
    await dbRef.update(updateMap);
    return;
    // return await getDriverWithDriverId(FirebaseAuth.instance.currentUser!.uid);
  }
}
