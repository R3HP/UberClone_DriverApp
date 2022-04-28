import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:taxi_line_driver/core/constants.dart';
import 'package:taxi_line_driver/core/service_locator.dart';
import 'package:taxi_line_driver/features/accounting/presentation/controller/auth_controller.dart';
import 'package:taxi_line_driver/features/cabing/data/model/trip.dart';
import 'package:taxi_line_driver/features/cabing/presentation/controller/trip_controller.dart';
import 'package:taxi_line_driver/features/cabing/presentation/widget/available_trips_container.dart';
import 'package:taxi_line_driver/features/cabing/presentation/widget/configured_flutter_map.dart';
import 'package:taxi_line_driver/features/cabing/presentation/widget/driver_availability_container.dart';
import 'package:taxi_line_driver/features/cabing/presentation/widget/gps_icon.dart';
import 'package:latlong2/latlong.dart';
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
  LocationData? currentLocationData;

  @override
  void initState() {
    super.initState();
    Location.instance.onLocationChanged.listen(rebuildOnUserLocationChange);
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
    return Scaffold(
      body: FutureBuilder(
          future: currentLocationData == null
              ? Location.instance.getLocation()
              : Future.value(currentLocationData),
          builder: (context, AsyncSnapshot<LocationData?> snapshot) {
            if (snapshot.hasData) {
              currentLocationData = snapshot.data;
              authController.currentLocationData = snapshot.data!;
              final startPosition = LatLng(
                  snapshot.data!.latitude!, snapshot.data!.longitude!);
              return Stack(
                children: [
                  ConfiguredFlutterMap(
                      mapController: _mapController,
                      startPosition: startPosition),
                  GpsIcon(
                      userLocation: startPosition,
                      shouldGoUp: true,
                      mapController: _mapController),
                  AvailableTripsContainer(startPosition: startPosition),
                  if (!authController.isAvailable)
                    DriverAvailabilityContainer(
                        authController: authController,
                        startPosition: startPosition),
                  if (authController.isAvailable)
                    SearchBar(mapController: _mapController),
                ],
              );
            } else if (snapshot.hasError) {
              return SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Text(snapshot.error.toString()));
            }else{
              return const SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Center(child: CircularProgressIndicator.adaptive()),
              );
            }
          }),
    );
  }

  void rebuildOnUserLocationChange(event) {
    if (currentLocationData != null) {
      if (currentLocationData!.latitude != event.latitude &&
          currentLocationData!.longitude != event.longitude) {
        setState(() {
          authController.currentLocationData = event;
          currentLocationData = event;
        });
        _mapController.move(
            LatLng(currentLocationData!.latitude!,
                currentLocationData!.longitude!),
            18.4);
      }
    }
  }
}
