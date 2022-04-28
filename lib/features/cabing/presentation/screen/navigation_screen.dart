import 'package:flutter/material.dart';
// import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
// import 'package:flutter_mapbox_navigation/library.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';

// import 'package:flutter_mapbox_navigation/library.dart';

import 'package:taxi_line_driver/features/cabing/data/model/way_point.dart'
    as myWayPoint;

class NavigationScreen extends StatefulWidget {
  static const routeName = '/navigation_screen';

  const NavigationScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  List<myWayPoint.WayPoint> waypoints = [];
  late MapBoxNavigation directions;
  MapBoxOptions options = MapBoxOptions(
      zoom: 18.0,
      animateBuildRoute: true,
      voiceInstructionsEnabled: true,
      bannerInstructionsEnabled: true,
      mode: MapBoxNavigationMode.drivingWithTraffic,
      isOptimized: true,
      units: VoiceUnits.metric,
      simulateRoute: true,
      language: 'en');
  late MapBoxNavigationViewController _controller;

  late WayPoint sourceWaypoint;
  late WayPoint destinationWaypoint;

  late double remainingDistance;
  late double remainingDuration;

  String instruction = '';
  bool arrived = false;
  bool routeBuilt = false;
  bool isNavigating = false;
  bool isMultipleStop = true;
  bool _isFirst = true;

  final navigationWayPoints = <WayPoint>[];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirst) {
      waypoints = ModalRoute.of(context)?.settings.arguments
          as List<myWayPoint.WayPoint>;
      for (var waypoint in waypoints) {
        navigationWayPoints.add(WayPoint(
            name: waypoint.name,
            longitude: waypoint.longitude,
            latitude: waypoint.latitude));
      }

      _isFirst = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(
          child: MapBoxNavigationView(
        options: options,
        onRouteEvent: _onEmbeddedRouteEvent,
        onCreated: (controller) {
          _controller = controller;

          controller.initialize();
          controller.buildRoute(wayPoints: navigationWayPoints);
          controller.startNavigation();
        },
      )),
      Consumer(
        builder: (ctx, ref, child) => ElevatedButton(
            onPressed: () {
              // ref.read(tripControllerProvider).finishPendingTrip();
              Navigator.of(context).pop();
            },
            child: const Text('Start another ride')),
      )
    ]));
  }

  Future<void> _onEmbeddedRouteEvent(e) async {
    remainingDistance = (await directions.distanceRemaining)!;
    remainingDuration = (await directions.durationRemaining)!;

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        if (progressEvent.currentStepInstruction != null) {
          instruction = progressEvent.currentStepInstruction!;
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        setState(() {
          routeBuilt = true;
        });
        break;
      case MapBoxEvent.route_build_failed:
        setState(() {
          routeBuilt = false;
        });
        break;
      case MapBoxEvent.navigation_running:
        setState(() {
          isNavigating = true;
        });
        break;
      case MapBoxEvent.on_arrival:
        if (!isMultipleStop) {
          await Future.delayed(Duration(seconds: 3));
          await _controller.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        setState(() {
          routeBuilt = false;
          isNavigating = false;
        });
        break;
      default:
        break;
    }
    setState(() {});
  }
}
