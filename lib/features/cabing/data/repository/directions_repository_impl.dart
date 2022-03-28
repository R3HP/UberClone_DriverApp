import 'package:latlong2/latlong.dart';
import 'package:taxi_line_driver/features/cabing/data/datasource/directions_data_source.dart';
import 'package:taxi_line_driver/features/cabing/data/model/direction.dart';
import 'package:taxi_line_driver/features/cabing/domain/repository/directions_repository.dart';

class DirectionsRepositoryImpl implements DirectionsRepository {
  final DirectionsDataSource directionDataSource;

  DirectionsRepositoryImpl({
    required this.directionDataSource,
    //5515161651
  });

  @override
  Future<Direction> getDirectionWithPoints(List<LatLng> points) async {
    try {
      final direction = await directionDataSource.getDirectionWithPoints(points);
      return direction;
    } catch (error) {
      throw UnimplementedError();
    }
  }

  
}
