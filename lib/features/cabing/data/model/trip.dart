import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:taxi_line_driver/features/cabing/data/model/route_model.dart';
import 'package:taxi_line_driver/features/cabing/data/model/way_point.dart';

class Trip {
  final String? id;
  final Route route;
  final double distance;
  final double duration;
  final List<WayPoint> wayPoints;
  final double price; 
  final DateTime createdAt;
  
  Trip({
    this.id,
    required this.route,
    required this.distance,
    required this.duration,
    required this.wayPoints,
    required this.price,
    required this.createdAt,
  });

  Trip copyWith({
    String? id,
    Route? route,
    double? distance,
    double? duration,
    List<WayPoint>? wayPoints,
    double? price,
    DateTime? createdAt,
  }) {
    return Trip(
      id: id,
      route: route ?? this.route,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      wayPoints: wayPoints ?? this.wayPoints,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'route': route.toMap(),
      'distance': distance,
      'duration': duration,
      'wayPoints': wayPoints.map((x) => x.toMap()).toList(),
      'price': price,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'],
      route: Route.fromMap(map['route']),
      distance: map['distance']?.toDouble() ?? 0.0,
      duration: map['duration']?.toDouble() ?? 0.0,
      wayPoints: List<WayPoint>.from(map['wayPoints']?.map((x) => WayPoint.fromMap(x))),
      price: map['price']?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Trip.fromJson(String source) => Trip.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Trip(route: $route, distance: $distance, duration: $duration, wayPoints: $wayPoints, price: $price, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Trip &&
      other.route == route &&
      other.distance == distance &&
      other.duration == duration &&
      listEquals(other.wayPoints, wayPoints) &&
      other.price == price &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return route.hashCode ^
      distance.hashCode ^
      duration.hashCode ^
      wayPoints.hashCode ^
      price.hashCode ^
      createdAt.hashCode;
  }
}
