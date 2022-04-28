import 'package:taxi_line_driver/features/cabing/data/model/trip.dart';
import 'package:taxi_line_driver/features/cabing/domain/repository/trip_repository.dart';

class SelectTripUseCase {
  final TripRepository tripRepository;

  SelectTripUseCase({
    required this.tripRepository,
  });

  Future<void> call(Trip trip) async {
    try {
      await tripRepository.selectTrip(trip);
      await tripRepository.deleteTripRequest(trip);
      return ;
    } catch (error) {
      rethrow;
    }
  }
}
