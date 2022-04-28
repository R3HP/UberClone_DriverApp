import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:taxi_line_driver/core/constants.dart';
import 'package:taxi_line_driver/core/service_locator.dart';

import 'package:taxi_line_driver/features/cabing/data/model/trip.dart';
import 'package:taxi_line_driver/features/cabing/presentation/controller/trip_controller.dart';
import 'package:taxi_line_driver/features/cabing/presentation/widget/trip_details_dialog.dart';

class ConfiguredFlutterMap extends StatelessWidget {
  final MapController mapController;
  final latlong.LatLng startPosition;

  const ConfiguredFlutterMap({
    Key? key,
    required this.mapController,
    required this.startPosition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TripController tripController = sl();
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        controller: mapController,
        maxZoom: 18.4,
        zoom: 18.4,
        center: startPosition,
      ),
      children: [
        TileLayerWidget(
          options: TileLayerOptions(
              urlTemplate:
                  'https://api.mapbox.com/styles/v1/r3zahp/cl04yaeqh000a15l2i8zdxib7/tiles/256/{z}/{x}/{y}@2x?access_token=$Your_Primary_Key',
              additionalOptions: {
                'accessToken': Your_Primary_Key,
                'id': 'mapbox.mapbox-streets-v8'
              }),
        ),
        StreamBuilder<List<Trip>>(
            stream: tripController.getTripStream(startPosition),
            builder: (context, AsyncSnapshot<List<Trip>> snapshot) {
              return MarkerLayerWidget(
                options: MarkerLayerOptions(markers: [
                  Marker(
                      point: startPosition,
                      builder: (context) => Image.asset('assets/images/car_android.png',)),
                  if (snapshot.hasData)
                    ...snapshot.data
                            ?.map((trip) => Marker(
                                  point: latlong.LatLng(
                                      trip.wayPoints.first.latitude,
                                      trip.wayPoints.first.longitude),
                                  builder: (ctx) => IconButton(
                                      icon: const Icon(Icons.location_history),
                                      color: Colors.green,
                                      onPressed: () =>
                                          showTripDescription(trip, context)),
                                ))
                            .toList() ??
                        []
                ]),
              );
            })
      ],
    );
  }

  void showTripDescription(Trip trip, BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) {
          return TripDetailsDialog(
            trip: trip,
          );
        });
  }
}
