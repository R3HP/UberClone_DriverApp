import 'package:taxi_line_driver/features/cabing/data/model/trip.dart';

abstract class TripRepository{
  Stream<List<Trip>> getTripRequestsStream();
  Future<void> selectTrip(Trip trip);
  Future<void> deleteTripRequest(Trip trip);
  Future<void> finishTripPending(Trip trip);
}