import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_line_driver/features/accounting/data/model/driver_model.dart';
import 'package:taxi_line_driver/features/cabing/data/model/trip.dart';

abstract class TripDataSource {
  Stream<List<Trip>> getTripsStreamFromDB();
  Future<void> selectTrip(Trip trip);
  Future<void> deleteTripRequest(Trip trip);
}

class TripDataSourceImpl implements TripDataSource {
  @override
  Stream<List<Trip>> getTripsStreamFromDB() {
    try {
      final dbRef = FirebaseDatabase.instance.ref().child('tripRequests');
      List<Trip> trips = [];
      // dbRef.onValue.listen((event) async {
      //   trips = await getTripsFromDB();
      //   yield trips;
      // });

      final x = dbRef.onValue.asyncMap((event) async => await getTripsFromDB());

      return x;

      // final stream = dbRef.onValue.asyncMap(
      //   (event) {
      //     final tripRequestMap = Map<String, dynamic>.fromIterables(
      //         event.snapshot.children.map((e) => e.key!),
      //         event.snapshot.children.map((e) => e.value));
      //     final trip = Trip.fromMap(tripRequestMap);
      //     return trip;
      //   },
      // );

      // return stream;
    } catch (error) {
      throw UnimplementedError();
    }
  }

  Future<List<Trip>> getTripsFromDB() async {
    try {
      final dbRef = FirebaseDatabase.instance.ref().child('tripRequests');
      final response = await dbRef.get();
      final trips = response.children
          .map((snapshot) => Trip.fromMap(Map.fromIterables(
              snapshot.children.map((e) => e.key!),
              snapshot.children.map((e) => e.value))..addAll({'id' : snapshot.key!})))
          .toList();
      // print(response.value.runtimeType);
      // final x = response.value as dynamic;
      // final y = x.map((internal) => Map.fromEntries([MapEntry(internal.key, internal.value)])).toList();
      // print(response.children.length);
      // final trips = response.children.map((e) => Trip.fromMap(Map<String,dynamic>.fromIterables([e.key!],[e.value]))).toList();

      return trips;
    } catch (error) {
      throw UnimplementedError();
    }
  }

  @override
  Future<void> selectTrip(Trip trip) async {
    try {
      final dbRef =
          FirebaseDatabase.instance.ref().child('trips').child(trip.id!);
      final response = await dbRef.set(trip.toMap()
        ..addAll({'driver': FirebaseAuth.instance.currentUser!.uid}));
      // final driverDbRef = FirebaseDatabase.instance.ref().child('drivers').child(FirebaseAuth.instance.currentUser!.uid);
      // await driverDbRef.child('trips').child(trip.id!).set({});
      // await driverDbRef.update({'credit' : trip.price});
      return response;
    } catch (error) {
      throw UnimplementedError();
    }
  }

  Future<void> deleteTripRequest(Trip trip) {
    try {
      final dbRef =
          FirebaseDatabase.instance.ref().child('tripRequests').child(trip.id!);
      final response = dbRef.remove();
      return response;
    } catch (error) {
      throw UnimplementedError();
    }
  }
}
