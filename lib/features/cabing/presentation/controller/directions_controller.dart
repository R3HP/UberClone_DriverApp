


import 'package:taxi_line_driver/features/cabing/data/model/direction.dart';
import 'package:taxi_line_driver/features/cabing/domain/usecase/get_directions_use_case.dart';
import 'package:latlong2/latlong.dart';

class DirectionsController {
  final GetDirectionsUseCase getDirectionsUseCase;

  DirectionsController({
    required this.getDirectionsUseCase,
  });


  Future<Direction> getDirectionForPoints(List<LatLng> points) async {
    try {
      final direction = await getDirectionsUseCase(points);
      return direction;
    } catch (error) {
      throw UnimplementedError();
    }
  }
}
