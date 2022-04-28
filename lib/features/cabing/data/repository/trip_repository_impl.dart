import 'package:taxi_line_driver/core/error.dart';
import 'package:taxi_line_driver/features/cabing/data/datasource/trip_data_source.dart';
import 'package:taxi_line_driver/features/cabing/data/model/trip.dart';
import 'package:taxi_line_driver/features/cabing/domain/repository/trip_repository.dart';

class TripRepositoryImpl implements TripRepository {
  final TripDataSource tripDataSource;

  TripRepositoryImpl({
    required this.tripDataSource,
  });
  
  @override
  Stream<List<Trip>> getTripRequestsStream()  {
    try {
      final trips =  tripDataSource.getTripsStreamFromDB();
      return trips;
    }catch (exception){
      throw Error(message: exception.toString());
    }
  }

  @override
  Future<void> selectTrip(Trip trip) async {
    try {
      final response = await tripDataSource.selectTrip(trip);
      return response;
    }catch (exception){
      throw Error(message: exception.toString());
    }
  }

  @override
  Future<void> deleteTripRequest(Trip trip) async {
    try {
      final response = await tripDataSource.deleteTripRequest(trip);
      return response;
    } catch (exception){
      throw Error(message: exception.toString());
    }
  }

  @override
  Future<void> finishTripPending(Trip trip) async {
    try {
      await tripDataSource.finishTrip(trip);
      final res= await tripDataSource.deletePendingTrip(trip);
      return res;
    } catch (exception){
      throw Error(message: exception.toString());
    }
  }
}
