import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scheduler_app/entities/stop.dart';

class LegFactory {
  static Leg fromJson(Map<String, dynamic> leg, String mode) {
    switch (mode) {
      case 'WALK':
        return WalkLeg.fromJson(leg);
      case 'BUS':
        return BusLeg.fromJson(leg);
      case 'SUBWAY':
        return RailLeg.fromJson(leg);
      default:
        throw Exception("Invalid mode $mode");
    }
  }
}

class Leg {
  final Stop origin;
  final Stop destination;
  final String serviceName;
  final List<Stop> intermediateStops;
  late List<Stop> allStops;
  final double distance;
  final int duration;
  final int endTime;
  final int startTime;
  final List<LatLng> polylineCoordinates;
  bool isCurrentLeg;

  Leg({
    required this.origin,
    required this.destination,
    required this.serviceName,
    required this.intermediateStops,
    required this.distance,
    required this.duration,
    required this.startTime,
    required this.endTime,
    required this.polylineCoordinates,
    this.isCurrentLeg = false,
  }) {
    allStops = [origin, ...intermediateStops, destination];
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
      Stop newStop = StopFactory.fromJson(stop, mode);
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
          intermediateStops: stops,
          distance: distance,
          duration: duration,
          startTime: startTime,
          endTime: endTime,
          polylineCoordinates: polylineCoordinates,
        );

  static BusLeg fromJson(Map<String, dynamic> legData) {
    return BusLeg(
      origin: StopFactory.fromJson(legData['from'], legData['mode']),
      destination: StopFactory.fromJson(legData['to'], legData['mode']),
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
          intermediateStops: stops,
          distance: distance,
          duration: duration,
          startTime: startTime,
          endTime: endTime,
          polylineCoordinates: polylineCoordinates,
        );

  static RailLeg fromJson(Map<String, dynamic> legData) {
    return RailLeg(
      origin: StopFactory.fromJson(legData['from'], legData['mode']),
      destination: StopFactory.fromJson(legData['to'], legData['mode']),
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
            intermediateStops: stops,
            distance: distance,
            duration: duration,
            startTime: startTime,
            endTime: endTime,
            polylineCoordinates: polylineCoordinates,
            serviceName: "Walking");

  static WalkLeg fromJson(Map<String, dynamic> legData) {
    return WalkLeg(
      origin: StopFactory.fromJson(legData['from'], legData['mode']),
      destination: StopFactory.fromJson(legData['to'], legData['mode']),
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
