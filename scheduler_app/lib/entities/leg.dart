import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:scheduler_app/entities/stop.dart';

class Leg {
  final Stop origin;
  final Stop destination;
  final String? serviceName;
  final List<Stop> stops;
  final double distance;
  final int duration;
  final int endTime;
  final int startTime;
  final List<LatLng> polylineCoordinates;

  Leg({
    required this.origin,
    required this.destination,
    this.serviceName,
    required this.stops,
    required this.distance,
    required this.duration,
    required this.startTime,
    required this.endTime,
    required this.polylineCoordinates,
  });

  static Leg create(Map<String, dynamic> leg, String mode) {
    switch (mode) {
      case 'WALK':
        return WalkLeg.fromJson(leg);
      case 'BUS':
        return BusLeg.fromJson(leg);
      case 'RAIL':
        return RailLeg.fromJson(leg);
      default:
        throw Exception("Invalid mode");
    }
  }

  static List<LatLng> decodePolylineCoordinates(String legGeometry) {
    List<LatLng> polylineCoordinates = [];

    List<List<num>> decodedPolyLines = decodePolyline(legGeometry);
    for (var i = 0; i < decodedPolyLines.length; i++) {
      polylineCoordinates.add(LatLng(decodedPolyLines[i][0].toDouble(),
          decodedPolyLines[i][1].toDouble()));
    }

    return polylineCoordinates;
  }

  static List<Stop> parseStops(List<dynamic> stops, mode) {
    List<Stop> parsedStops = [];

    for (Map<String, dynamic> stop in stops) {
      Stop newStop = Stop.create(stop, mode);
      parsedStops.add(newStop);
    }

    return parsedStops;
  }
}

class BusLeg extends Leg {
  BusLeg({
    required Stop origin,
    required Stop destination,
    required String serviceName,
    required List<Stop> stops,
    required double distance,
    required int duration,
    required int startTime,
    required int endTime,
    required List<LatLng> polylineCoordinates,
  }) : super(
          origin: origin,
          destination: destination,
          serviceName: serviceName,
          stops: stops,
          distance: distance,
          duration: duration,
          startTime: startTime,
          endTime: endTime,
          polylineCoordinates: polylineCoordinates,
        );

  static BusLeg fromJson(Map<String, dynamic> legData) {
    return BusLeg(
      origin: Stop.create(legData['from'], legData['mode']),
      destination: Stop.create(legData['to'], legData['mode']),
      serviceName: legData['route'],
      stops: Leg.parseStops(legData['intermediateStops'], legData['mode']),
      distance: legData['distance'],
      duration: legData['duration'],
      startTime: legData['startTime'],
      endTime: legData['endTime'],
      polylineCoordinates:
          Leg.decodePolylineCoordinates(legData['legGeometry']['points']),
    );
  }
}

class RailLeg extends Leg {
  RailLeg({
    required Stop origin,
    required Stop destination,
    required String serviceName,
    required List<Stop> stops,
    required double distance,
    required int duration,
    required int startTime,
    required int endTime,
    required List<LatLng> polylineCoordinates,
  }) : super(
          origin: origin,
          destination: destination,
          serviceName: serviceName,
          stops: stops,
          distance: distance,
          duration: duration,
          startTime: startTime,
          endTime: endTime,
          polylineCoordinates: polylineCoordinates,
        );

  static RailLeg fromJson(Map<String, dynamic> legData) {
    return RailLeg(
      origin: Stop.create(legData['from'], legData['mode']),
      destination: Stop.create(legData['to'], legData['mode']),
      serviceName: legData['route'],
      stops: Leg.parseStops(legData['intermediateStops'], legData['mode']),
      distance: legData['distance'],
      duration: legData['duration'],
      startTime: legData['startTime'],
      endTime: legData['endTime'],
      polylineCoordinates:
          Leg.decodePolylineCoordinates(legData['legGeometry']['points']),
    );
  }
}

class WalkLeg extends Leg {
  WalkLeg({
    required Stop origin,
    required Stop destination,
    required List<Stop> stops,
    required double distance,
    required int duration,
    required int startTime,
    required int endTime,
    required List<LatLng> polylineCoordinates,
  }) : super(
          origin: origin,
          destination: destination,
          stops: stops,
          distance: distance,
          duration: duration,
          startTime: startTime,
          endTime: endTime,
          polylineCoordinates: polylineCoordinates,
        );

  static WalkLeg fromJson(Map<String, dynamic> legData) {
    return WalkLeg(
      origin: Stop.create(legData['from'], legData['mode']),
      destination: Stop.create(legData['to'], legData['mode']),
      stops: [],
      distance: legData['distance'],
      duration: legData['duration'],
      startTime: legData['startTime'],
      endTime: legData['endTime'],
      polylineCoordinates:
          Leg.decodePolylineCoordinates(legData['legGeometry']['points']),
    );
  }
}
