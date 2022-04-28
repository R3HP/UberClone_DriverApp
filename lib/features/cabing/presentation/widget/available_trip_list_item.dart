import 'package:flutter/material.dart';

import 'package:taxi_line_driver/features/cabing/data/model/trip.dart';
import 'package:taxi_line_driver/features/cabing/presentation/widget/trip_details_dialog.dart';

class AvailableTripListItem extends StatelessWidget {
  final Trip trip;

  const AvailableTripListItem({
    Key? key,
    required this.trip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                        side: const BorderSide(color: Colors.grey,)
                      ),
                      onTap: () => showTripDescription(trip,context),
                      title: FittedBox(
                          child: Text(
                              'start: ${trip.wayPoints.first.name} _ finish: ${trip.wayPoints.last.name}')),
                      subtitle:
                          Text(trip.price.toStringAsFixed(2)),
                      trailing: Text(trip.duration.toString()),
                      leading: Text(trip.distance.toString()),
                    );
  }

  void showTripDescription(Trip trip,BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) {
          return TripDetailsDialog(
            trip: trip,
          );
        });
  }
}
