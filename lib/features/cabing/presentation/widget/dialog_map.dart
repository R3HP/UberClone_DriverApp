import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:taxi_line_driver/features/cabing/data/model/trip.dart';
import 'package:latlong2/latlong.dart';

class DialogMap extends StatelessWidget {
  const DialogMap({
    Key? key,
    required this.trip,
  }) : super(key: key);

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
        options: MapOptions(
          screenSize: Size(MediaQuery.of(context).size.width * 0.6,
              MediaQuery.of(context).size.height * 0.2),
          maxZoom: 18.4,
          zoom: 18.4,
          onMapCreated: (controller) {
            controller.onReady.then((value) {
              final centerZoom =
                  controller.centerZoomFitBounds(LatLngBounds(
                LatLng(
                  trip.wayPoints.first.latitude,
                  trip.wayPoints.first.longitude,
                ),
                LatLng(
                  trip.wayPoints.last.latitude,
                  trip.wayPoints.last.longitude,
                ),
              ));

              controller.move(centerZoom.center, centerZoom.zoom);
            });
          },
        ),
        children: [
          TileLayerWidget(
            options: TileLayerOptions(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/r3zahp/cl04yaeqh000a15l2i8zdxib7/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicjN6YWhwIiwiYSI6ImNrYnhmc2JhbzA1bTAyc3Fubm5paHZqd2sifQ.kiQxWPBep95bN00r41U7Rg',
                additionalOptions: {
                  'accessToken':
                      'pk.eyJ1IjoicjN6YWhwIiwiYSI6ImNrYnhmc2JhbzA1bTAyc3Fubm5paHZqd2sifQ.kiQxWPBep95bN00r41U7Rg',
                  'id': 'mapbox.mapbox-streets-v8'
                }),
          ),
          MarkerLayerWidget(
            options: MarkerLayerOptions(markers: [
              Marker(
                point: LatLng(
                  trip.wayPoints.first.latitude,
                  trip.wayPoints.first.longitude,
                ),
                builder: (ctx) => const Icon(
                  Icons.location_history,
                  color: Colors.blue,
                ),
              ),
              Marker(
                point: LatLng(
                  trip.wayPoints.last.latitude,
                  trip.wayPoints.last.longitude,
                ),
                builder: (ctx) => const Icon(
                  Icons.location_on,
                  color: Colors.red,
                ),
              ),
            ]),
          ),
          PolylineLayerWidget(
            options: PolylineLayerOptions(polylines: [
              Polyline(
                points: trip.route.geometryCordinates,
                color: Colors.green,
                strokeWidth: 2,
              )
            ]),
          )
        ]);
  }
}
