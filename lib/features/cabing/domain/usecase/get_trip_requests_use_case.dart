import 'package:taxi_line_driver/features/cabing/data/model/trip.dart';
import 'package:taxi_line_driver/features/cabing/domain/repository/trip_repository.dart';

class GetTripRequestsUseCase {
  final TripRepository tripRepository;
  GetTripRequestsUseCase({
    required this.tripRepository,
  });

  Stream<List<Trip>> call() {
    try {
      final stream = tripRepository.getTripRequestsStream();
      return stream;
    } catch (error) {
      throw UnimplementedError();
    }
  }
}
