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
  Leg(Map<String, dynamic> leg) {
    // decode geometry and add to polylineCoordinates
    decodeAndAddToPolylineCoordinates(leg['legGeometry']['points']);

    // initialize start

    // initialize dest

    // intialize legType

    // intialize distance

    // initalize duration

    // intialize endTime
  }

  void decodeAndAddToPolylineCoordinates(String legGeometry) {
    List<List<num>> decodedPolyLines = decodePolyline(legGeometry);
    for (var i = 0; i < decodedPolyLines.length; i++) {
      polylineCoordinates.add(LatLng(decodedPolyLines[i][0].toDouble(),
          decodedPolyLines[i][1].toDouble()));
    }
  }
}
