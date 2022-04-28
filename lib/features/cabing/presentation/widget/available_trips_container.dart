import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:taxi_line_driver/features/cabing/presentation/widget/trip_request_list.dart';

class AvailableTripsContainer extends StatelessWidget {
  const AvailableTripsContainer({
    Key? key,
    required this.startPosition,
  }) : super(key: key);

  final LatLng startPosition;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: TripRequestList(startPosition: startPosition),
    );
  }
}
