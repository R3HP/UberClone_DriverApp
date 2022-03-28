import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:taxi_line_driver/core/service_locator.dart';
import 'package:taxi_line_driver/features/accounting/presentation/controller/auth_controller.dart';
import 'package:taxi_line_driver/features/cabing/data/model/trip.dart';
import 'package:taxi_line_driver/features/cabing/presentation/controller/directions_controller.dart';
import 'package:taxi_line_driver/features/cabing/presentation/controller/trip_controller.dart';
import 'package:taxi_line_driver/features/cabing/presentation/widget/gps_icon.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:taxi_line_driver/features/cabing/presentation/widget/search_bar.dart';
import 'package:taxi_line_driver/features/cabing/presentation/widget/trip_details_dialog.dart';
import 'package:taxi_line_driver/features/cabing/presentation/widget/trip_request_list.dart';

class CabScreen extends ConsumerStatefulWidget {
  const CabScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CabScreen> createState() => _CabScreenState();
}

class _CabScreenState extends ConsumerState<CabScreen> {
  final _mapController = MapController();
  late final AuthController authController;
  bool _isFirst = true;
  final TripController tripController = sl();
  LocationData? currentLocationData;

  @override
  void initState() {
    super.initState();
    Location.instance.onLocationChanged.listen((event) {
      print(currentLocationData == null);
      if (currentLocationData != null) {
        if (currentLocationData!.latitude != event.latitude &&
            currentLocationData!.longitude != event.longitude) {
          setState(() {
            authController.currentLocationData = event;
            currentLocationData = event;
          });
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirst) {
      authController = ref.watch(authControllerProvider);
      _isFirst = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('cab screen build');
    return Scaffold(
      body: FutureBuilder(
        future: currentLocationData == null
            ? Location.instance.getLocation()
            : Future.value(currentLocationData),
        builder: (context, AsyncSnapshot<LocationData?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              currentLocationData = snapshot.data;
              authController.currentLocationData = snapshot.data!;
              final startPosition = latlong.LatLng(
                  snapshot.data!.latitude!, snapshot.data!.longitude!);
              return Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      controller: _mapController,
                      maxZoom: 18.4,
                      zoom: 18.4,
                      center: startPosition,
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
                      StreamBuilder<List<Trip>>(
                          stream: tripController.getTripStream(startPosition),
                          builder:
                              (context, AsyncSnapshot<List<Trip>> snapshot) {
                            return MarkerLayerWidget(
                              options: MarkerLayerOptions(markers: [
                                Marker(
                                    point: startPosition,
                                    builder: (context) =>
                                        const Icon(Icons.car_rental)),
                                if (snapshot.hasData)
                                  ...snapshot.data
                                          ?.map((trip) => Marker(
                                                point: latlong.LatLng(
                                                    trip.wayPoints.first
                                                        .latitude,
                                                    trip.wayPoints.first
                                                        .longitude),
                                                builder: (ctx) => IconButton(
                                                    icon: const Icon(
                                                        Icons.location_history),
                                                    color: Colors.green,
                                                    onPressed: () =>
                                                        showTripDescription(
                                                            trip)
                                                    // () async {

                                                    //   await tripController.selectTrip(trip);
                                                    //   await authController.updateDriver({'credit' : authController.currentDriver!.credit + trip.price});
                                                    // }
                                                    ),
                                              ))
                                          .toList() ??
                                      []
                              ]),
                            );
                          })
                    ],
                  ),
                  GpsIcon(
                      userLocation: startPosition,
                      shouldGoUp: true,
                      mapController: _mapController),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: TripRequestList(startPosition: startPosition),
                  ),
                  if (!authController.isAvailable)
                    Positioned(
                      top: 20,
                      left: 50,
                      right: 50,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 20,
                        shadowColor: Colors.black54,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('You Are Not Available Yet'),
                            ElevatedButton(
                                onPressed: () =>
                                    authController.makeAvailable(startPosition),
                                child: const Text('Go Online'),
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)))),
                          ],
                        ),
                      ),
                    ),
                  if (authController.isAvailable)
                    SearchBar(mapController: _mapController),
                ],
              );
            }
          }
        },
      ),
    );
  }

  void showTripDescription(Trip trip) {
    showDialog(
        context: context,
        builder: (ctx) {
          return TripDetailsDialog(
            trip: trip,
          );
        });
  }
}

