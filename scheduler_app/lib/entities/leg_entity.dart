import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'legtype_entity.dart';
import 'location_entity.dart';

class Leg {
  List<LatLng> polylineCoordinates = [];
  late Location start;
  late Location dest;
  late LegType legType;
  late double distance;
  late int duration;
  late int endTime;
  late int startTime;
  Leg(Map<String, dynamic> leg) {
    // decode geometry and add to polylineCoordinates
    decodeAndAddToPolylineCoordinates(leg['legGeometry']['points']);

    // initialize start
    Map<String, dynamic> from = leg['from'];
    start = Location(lat: from['lat'], lon: from['lon'], name: from['name']);

    // initialize dest
    Map<String, dynamic> to = leg['to'];
    dest = Location(lat: to['lat'], lon: to['lon'], name: to['name']);

    // intialize legType using a Simple Factory Pattern
    String mode = leg['mode'];
    try {
      LegFactory.createLegType(mode, leg);
    } catch (e) {
      debugPrint(e.toString());
    }

    // intialize distance
    distance = leg['distance'];

    // initalize duration
    duration = leg['duration'];

    // intialize endTime
    endTime = leg['endTime'];

    // intialize startTime
    startTime = leg['startTime'];
  }

  void decodeAndAddToPolylineCoordinates(String legGeometry) {
    List<List<num>> decodedPolyLines = decodePolyline(legGeometry);
    for (var i = 0; i < decodedPolyLines.length; i++) {
      polylineCoordinates.add(LatLng(decodedPolyLines[i][0].toDouble(),
          decodedPolyLines[i][1].toDouble()));
    }
  }
}
