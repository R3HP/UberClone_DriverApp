// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:mapbox_navigation/mapbox_navigation.dart';

// class NavigationScreen extends StatefulWidget {
//   const NavigationScreen({Key? key}) : super(key: key);

//   @override
//   State<NavigationScreen> createState() => _NavigationScreenState();
// }

// class _NavigationScreenState extends State<NavigationScreen> {
//   MapViewController controller;
//   var mapBox = MapboxNavigation();

//   @override
//   void initState() {
//     super.initState();
//     mapBox.init();

//     mapBox.getMapBoxEventResults().onData((data) {
//       print("Event: ${data.eventName}, Data: ${data.data}");

//       var event = MapBoxEventProvider.getEventType(data.eventName);

//       if (event == MapBoxEvent.route_building) {
//         print('route Building');
//       } else if (event == MapBoxEvent.route_build_failed) {
//         print('Route Build Failed');
//       } else if (event == MapBoxEvent.route_built) {
//         var routeResponse = MapBoxRouteResponse.fromJson(jsonDecode(data.data));

//         controller
//             .getFormattedDistance(routeResponse.routes.first.distance)
//             .then((value) => print("Route Distance: $value"));

//         controller
//             .getFormattedDuration(routeResponse.routes.first.duration)
//             .then((value) => print("Route Duration: $value"));
//       } else if (event == MapBoxEvent.progress_change) {
//         var progressEvent = MapBoxProgressEvent.fromJson(jsonDecode(data.data));

//         controller
//             .getFormattedDistance(progressEvent.legDistanceRemaining)
//             .then((value) => print("Leg Distance Remaining: $value"));

//         controller
//             .getFormattedDistance(progressEvent.distanceTraveled)
//             .then((value) => print("Distance Travelled: $value"));

//         controller
//             .getFormattedDuration(progressEvent.legDurationRemaining)
//             .then((value) => print("Leg Duration Remaining: $value"));

//         print("Voice Instruction: ${progressEvent.voiceInstruction},"
//             "Banner Instruction: ${progressEvent.bannerInstruction}");
//       } else if (event == MapBoxEvent.milestone_event) {
//         var mileStoneEvent =
//             MapBoxMileStoneEvent.fromJson(jsonDecode(data.data));

//         controller
//             .getFormattedDistance(mileStoneEvent.distanceTraveled)
//             .then((value) => print("Distance Travelled: $value"));
//       } else if (event == MapBoxEvent.speech_announcement) {
//         var speechEvent = MapBoxEventData.fromJson(jsonDecode(data.data));
//         print("Speech Text: ${speechEvent.data}");
//       } else if (event == MapBoxEvent.banner_instruction) {
//         var bannerEvent = MapBoxEventData.fromJson(jsonDecode(data.data));
//         print("Banner Text: ${bannerEvent.data}");
//       } else if (event == MapBoxEvent.navigation_cancelled) {
//       } else if (event == MapBoxEvent.navigation_finished) {
//       } else if (event == MapBoxEvent.on_arrival) {
//       } else if (event == MapBoxEvent.user_off_route) {
//         var locationData = MapBoxLocation.fromJson(jsonDecode(data.data));
//         print("User has off-routed: Location: ${locationData.toString()}");
//       } else if (event == MapBoxEvent.faster_route_found) {
//         var routeResponse = MapBoxRouteResponse.fromJson(jsonDecode(data.data));

//         controller
//             .getFormattedDistance(routeResponse.routes.first.distance)
//             .then(
//                 (value) => print("Faster route found: Route Distance: $value"));

//         controller
//             .getFormattedDuration(routeResponse.routes.first.duration)
//             .then(
//                 (value) => print("Faster route found: Route Duration: $value"));
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: MapBoxMapView(
//         onMapViewCreated: (controller) {
//           controller.startNavigation()
//         },
//       ),
//     );
//   }
// }
