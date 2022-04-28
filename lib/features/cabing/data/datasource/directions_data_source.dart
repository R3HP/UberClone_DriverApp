import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:taxi_line_driver/core/constants.dart';

import 'package:taxi_line_driver/features/cabing/data/model/direction.dart';


abstract class DirectionsDataSource{
  Future<Direction> getDirectionWithPoints(List<LatLng> points);
}


class DirectionsDataSourceImpl implements DirectionsDataSource {
  final Dio dio ;

  DirectionsDataSourceImpl({
    required this.dio,
  });

  @override
  Future<Direction> getDirectionWithPoints(List<LatLng> points) async {
    try {
      final pathSeqments = [
        'directions' , 'v5' , 'mapbox' , 'driving-traffic' , points.fold<String>('', (previousValue, element) => previousValue + element.longitude.toString() + ',' + element.latitude.toString() + (points.last.latitude == element.latitude ? '' : ';') )
      ];
      final queryParameters = {'geometries': 'geojson', 'steps': 'true', 'access_token': Your_Primary_Key};
      final newUrl = Uri(host: 'api.mapbox.com',pathSegments: pathSeqments,scheme: 'https' , queryParameters: queryParameters,);
      final response = await dio.getUri(newUrl);
      final direction = Direction.fromMapBoxMap(response.data);
      return direction;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

}
