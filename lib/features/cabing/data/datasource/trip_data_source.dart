import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:taxi_line_driver/features/cabing/data/model/trip.dart';

abstract class TripDataSource {
  Stream<List<Trip>> getTripsStreamFromDB();
  Future<void> selectTrip(Trip trip);
  Future<void> deleteTripRequest(Trip trip);
  Future<void> finishTrip(Trip trip);
  Future<void> deletePendingTrip(Trip trip);
}

class TripDataSourceImpl implements TripDataSource {
  @override
  Stream<List<Trip>> getTripsStreamFromDB() {
    try {
      final dbRef = FirebaseDatabase.instance.ref().child('tripRequests');
      final stream = dbRef.onValue.asyncMap((event) async => await getTripsFromDB());
      return stream;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Future<List<Trip>> getTripsFromDB() async {
    try {
      final dbRef = FirebaseDatabase.instance.ref().child('tripRequests');
      final response = await dbRef.get();
      final trips = response.children
          .map((snapshot) => Trip.fromMap(Map.fromIterables(
              snapshot.children.map((e) => e.key!),
              snapshot.children.map((e) => e.value))
            ..addAll({'id': snapshot.key!})))
          .toList();
      return trips;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  @override
  Future<void> selectTrip(Trip trip) async {
    try {
      final dbRef =
          FirebaseDatabase.instance.ref().child('pendingTrips').child(trip.id!);
      final response = await dbRef.set(trip.toMap()
        ..addAll({'driver': FirebaseAuth.instance.currentUser!.uid}));
      return response;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  @override
  Future<void> deleteTripRequest(Trip trip) async {
    try {
      final dbRef =
          FirebaseDatabase.instance.ref().child('tripRequests').child(trip.id!);
      final response = await dbRef.remove();
      return response;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  @override
  Future<void> finishTrip(Trip trip) async {
    try {
      final dbRef =
          FirebaseDatabase.instance.ref().child('pendingTrips').child(trip.id!);
      final response = await dbRef.set(trip.toMap()
        ..addAll({'driver': FirebaseAuth.instance.currentUser!.uid}));
      return response;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  @override
  Future<void> deletePendingTrip(Trip trip) async {
    try {
      final dbRef =
          FirebaseDatabase.instance.ref().child('pendingTrips').child(trip.id!);
      final response = await dbRef.remove();
      return response;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }
}
