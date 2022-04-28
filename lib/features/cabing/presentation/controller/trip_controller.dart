import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import 'package:taxi_line_driver/core/service_locator.dart';
import 'package:taxi_line_driver/features/cabing/data/model/trip.dart';
import 'package:taxi_line_driver/features/cabing/domain/usecase/finish_pending_trip_use_case.dart';
import 'package:taxi_line_driver/features/cabing/domain/usecase/get_trip_requests_use_case.dart';
import 'package:taxi_line_driver/features/cabing/domain/usecase/select_trip_use_case.dart';

final tripControllerProvider = ChangeNotifierProvider((ref) => TripController(
    getTripRequestsUseCase: sl(),
    selectTripUseCase: sl(),
    finishPendingTripUseCase: sl()));

class TripController with ChangeNotifier {
  final GetTripRequestsUseCase _getTripRequestsUseCase;
  final SelectTripUseCase _selectTripUseCase;
  final FinishPendingTripUseCase _finishPendingTripUseCase;

  List<Trip> _trips = [];
  TripController({
    required GetTripRequestsUseCase getTripRequestsUseCase,
    required SelectTripUseCase selectTripUseCase,
    required FinishPendingTripUseCase finishPendingTripUseCase,
  })  : _getTripRequestsUseCase = getTripRequestsUseCase,
        _finishPendingTripUseCase = finishPendingTripUseCase,
        _selectTripUseCase = selectTripUseCase;

  List<Trip> get trips => List<Trip>.from(_trips);

  Trip? selectedTrip;

  void setUpTrips(LatLng currentLocation) {
    final tripsListStream = _getTripRequestsUseCase();
    tripsListStream.listen((tripsList) {
      _trips = tripsList;
      _trips = sortTripsBasedRange(_trips, currentLocation);
    });
  }

  Stream<List<Trip>> getTripStream(LatLng currentLocation) {
    final tripsStream = _getTripRequestsUseCase();

    final tripsOrderedStream =
        tripsStream.map((event) => sortTripsBasedRange(event, currentLocation));
    return tripsOrderedStream;
  }

  Future<void> selectTrip(Trip trip) async {
    final response = await _selectTripUseCase(trip);
    selectedTrip = trip;
    return response;
  }

  Future<void> finishPendingTrip() async {
    final response = await _finishPendingTripUseCase(selectedTrip!);
    selectedTrip = null;
    return response;
  }

  List<Trip> sortTripsBasedRange(List<Trip> trips, LatLng currentLocation) {
    final orderedTrips = trips..sort((a, b) {
        final fisrtTripDistanceToCurrentLocation = const Distance().call(
            LatLng(a.wayPoints.first.latitude, a.wayPoints.first.longitude),
            currentLocation);
        final secondTripDistanceToCurrentLocation = const Distance().call(
            LatLng(b.wayPoints.first.latitude, b.wayPoints.first.longitude),
            currentLocation);
        return fisrtTripDistanceToCurrentLocation
            .compareTo(secondTripDistanceToCurrentLocation);
      });
    return orderedTrips;
  }
}
