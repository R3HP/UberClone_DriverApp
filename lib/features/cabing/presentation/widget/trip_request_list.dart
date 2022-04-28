import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'package:taxi_line_driver/core/service_locator.dart';
import 'package:taxi_line_driver/features/cabing/data/model/trip.dart';
import 'package:taxi_line_driver/features/cabing/presentation/controller/trip_controller.dart';
import 'package:taxi_line_driver/features/cabing/presentation/widget/available_trip_list_item.dart';
import 'package:taxi_line_driver/features/cabing/presentation/widget/trip_details_dialog.dart';

class TripRequestList extends StatefulWidget {
  final LatLng startPosition;

  const TripRequestList({
    Key? key,
    required this.startPosition,
  }) : super(key: key);

  @override
  State<TripRequestList> createState() => _TripRequestListState();
}

class _TripRequestListState extends State<TripRequestList> {
  late final TripController tripController;

  final List<Trip> trips = [];

  @override
  void initState() {
    super.initState();
    tripController = sl();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 20,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: 200,
        child: StreamBuilder(
          stream: tripController.getTripStream(widget.startPosition),
          builder: (ctx, AsyncSnapshot<List<Trip>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                widthFactor: 0.7,
                child: LinearProgressIndicator(),
              );
            } else {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                if (snapshot.data!.isEmpty) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (ctx, index) =>
                          AvailableTripListItem(trip: snapshot.data![index]));
                } else {
                  return const Center(
                    child: Text('No Trip Requests Found'),
                  );
                }
              }
            }
          },
        ),
      ),
    );
  }
}
