import 'package:taxi_line_driver/features/cabing/data/model/direction.dart';
import 'package:latlong2/latlong.dart';

abstract class DirectionsRepository{
  Future<Direction> getDirectionWithPoints(List<LatLng> points);
}