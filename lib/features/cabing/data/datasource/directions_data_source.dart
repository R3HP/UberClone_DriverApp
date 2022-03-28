import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

import 'package:taxi_line_driver/features/cabing/data/model/direction.dart';

// 'https://api.mapbox.com/directions/v5/mapbox/driving-traffic/121.448074,31.312383;121.456237,31.298638;121.443439,31.28109?geometries=geojson&steps=true&access_token=pk.eyJ1IjoicjN6YWhwIiwiYSI6ImNrYnhmc2JhbzA1bTAyc3Fubm5paHZqd2sifQ.kiQxWPBep95bN00r41U7Rg'
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
      // final url = Uri.parse('https://api.mapbox.com/directions/v5/mapbox/driving-traffic/${points.first.longitude},${points.first.latitude};${points[1].longitude},${points[1].latitude};${points[2].longitude},${points[2].latitude}?geometries=geojson&steps=true&access_token=pk.eyJ1IjoicjN6YWhwIiwiYSI6ImNrYnhmc2JhbzA1bTAyc3Fubm5paHZqd2sifQ.kiQxWPBep95bN00r41U7Rg');
      final pathSeqments = [
        'directions' , 'v5' , 'mapbox' , 'driving-traffic' , points.fold<String>('', (previousValue, element) => previousValue + element.longitude.toString() + ',' + element.latitude.toString() + ';')
      ];
      final queryParameters = {'geometries': 'geojson', 'steps': true, 'access_token': 'pk.eyJ1IjoicjN6YWhwIiwiYSI6ImNrYnhmc2JhbzA1bTAyc3Fubm5paHZqd2sifQ.kiQxWPBep95bN00r41U7Rg'};
      final newUrl = Uri(host: 'api.mapbox.com',pathSegments: pathSeqments,scheme: 'https' , queryParameters: queryParameters,);
      final response = await dio.getUri(newUrl);
      final direction = Direction.fromMapBoxMap(response.data);
      return direction;
    } catch (error) {
      throw UnimplementedError();
    }
  }

}
