import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import 'package:taxi_line_driver/core/service_locator.dart';
import 'package:taxi_line_driver/features/cabing/data/model/trip.dart';
import 'package:taxi_line_driver/features/cabing/domain/usecase/get_trip_requests_use_case.dart';
import 'package:taxi_line_driver/features/cabing/domain/usecase/select_trip_use_case.dart';

final tripControllerProvider = ChangeNotifierProvider((ref) => TripController(getTripRequestUseCase: sl(),selectTripUseCase: sl()));

class TripController with ChangeNotifier {
  final GetTripRequestsUseCase getTripRequestUseCase;
  final SelectTripUseCase selectTripUseCase;

  List<Trip> _trips = [];

  TripController({
    required this.getTripRequestUseCase,
    required this.selectTripUseCase,
  });

  List<Trip> get trips => List<Trip>.from(_trips);

  void setUpTrips(LatLng currentLocation) {
    final tripsListStream = getTripRequestUseCase();
    tripsListStream.listen((tripsList) {
      _trips = tripsList
        ..sort((a, b) {
          final fisrtTripDistanceToCurrentLocation = const Distance().call(
              LatLng(a.wayPoints.first.latitude, a.wayPoints.first.longitude),
              currentLocation);
          final secondTripDistanceToCurrentLocation = const Distance().call(
              LatLng(b.wayPoints.first.latitude, b.wayPoints.first.longitude),
              currentLocation);
          return fisrtTripDistanceToCurrentLocation
              .compareTo(secondTripDistanceToCurrentLocation);
        });
    });
  }

  Stream<List<Trip>> getTripStream(LatLng currentLocation) {
    final trips = getTripRequestUseCase();

    final tripsOrdered = trips.map((event) => event
      ..sort((a, b) {
        final fisrtTripDistanceToCurrentLocation = const Distance().call(
            LatLng(a.wayPoints.first.latitude, a.wayPoints.first.longitude),
            currentLocation);
        final secondTripDistanceToCurrentLocation = const Distance().call(
            LatLng(b.wayPoints.first.latitude, b.wayPoints.first.longitude),
            currentLocation);
        return fisrtTripDistanceToCurrentLocation
            .compareTo(secondTripDistanceToCurrentLocation);
      }));
    return tripsOrdered;
  }

  Future<void> selectTrip(Trip trip) async {
    final response = await selectTripUseCase(trip);
    return response;
  }
}
