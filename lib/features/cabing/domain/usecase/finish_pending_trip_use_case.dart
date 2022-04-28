import 'package:taxi_line_driver/features/cabing/data/model/trip.dart';
import 'package:taxi_line_driver/features/cabing/domain/repository/trip_repository.dart';

class FinishPendingTripUseCase {
  final TripRepository tripRepository;

  FinishPendingTripUseCase({
    required this.tripRepository,
  });

  Future<void> call(Trip trip) async {
    try {
      final response = await tripRepository.finishTripPending(trip);
      return response;
    } catch (error) {
      rethrow;
    }
  }
}
