import 'package:taxi_line_driver/features/cabing/data/model/direction.dart';
import 'package:taxi_line_driver/features/cabing/domain/repository/directions_repository.dart';
import 'package:latlong2/latlong.dart';

class GetDirectionsUseCase {
  final DirectionsRepository directionRepository;

  GetDirectionsUseCase({
    required this.directionRepository,
  });


  Future<Direction> call(List<LatLng> points) async {
    try {
      final direction = await directionRepository.getDirectionWithPoints(points);
      return direction;
    } catch (error) {
      throw UnimplementedError();
    }
  }
}
