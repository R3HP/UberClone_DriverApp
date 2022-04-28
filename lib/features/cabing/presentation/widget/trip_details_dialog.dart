import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import 'package:taxi_line_driver/core/service_locator.dart';
import 'package:taxi_line_driver/features/accounting/presentation/controller/auth_controller.dart';
import 'package:taxi_line_driver/features/cabing/data/model/trip.dart';
import 'package:taxi_line_driver/features/cabing/presentation/controller/directions_controller.dart';
import 'package:taxi_line_driver/features/cabing/presentation/controller/trip_controller.dart';
import 'package:taxi_line_driver/features/cabing/presentation/screen/navigation_screen.dart';
import 'package:taxi_line_driver/features/cabing/presentation/widget/dialog_map.dart';
import 'package:taxi_line_driver/features/cabing/presentation/widget/trip_detail_dialog_field.dart';

class TripDetailsDialog extends StatelessWidget {
  TripDetailsDialog({
    Key? key,
    required this.trip,
  }) : super(key: key);

  final Trip trip;
  final TripController tripController = sl();
  final DirectionsController directionsController = sl();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trip.wayPoints.first.name != null &&
                trip.wayPoints.last.name != null)
              Text('Trip From' +
                  trip.wayPoints.first.name! +
                  'To ' +
                  trip.wayPoints.last.name!),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.8,
              child: DialogMap(trip: trip),
            ),
            TripDetailDialogField(label: 'Price :' ,value: '\$' + trip.price.toStringAsFixed(2)),
            TripDetailDialogField(label: 'Duration :' ,value: trip.duration.toStringAsFixed(0) + '\'s' ),
            TripDetailDialogField(label: 'Distance :' ,value: trip.route.distanceAsKM.toStringAsFixed(2) + 'KM'),
            Consumer(
              builder: (context, ref, child) => ElevatedButton(
                onPressed: () async {
                  final authController = ref.read(authControllerProvider);
                  if (!authController.isAvailable) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You should Be Available First')));
                    Navigator.of(context).pop();
                    return;
                  } 
                  await tripController.selectTrip(trip);
                  // await authController.updateDriver({
                  //   'credit': authController.currentDriver!.credit + trip.price
                  // });
                  final points = [
                    LatLng(authController.currentLocationData.latitude!,
                        authController.currentLocationData.longitude!),
                    ...trip.wayPoints.map((wayPoint) =>
                        LatLng(wayPoint.latitude, wayPoint.longitude)),
                  ];
                  final direction = await directionsController.getDirectionForPoints(points);
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(NavigationScreen.routeName,arguments: direction.waypoints);
                },
                child: const Text('Take The Trip'),
                style: ElevatedButton.styleFrom(
                  
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    fixedSize: const Size(350, 50)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

