import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'leg.dart';
import 'duration.dart';

class Route {
  late int mapIndex;
  List<Leg> legs = [];
  late List<LatLng> decodedLegGoemetry;
  late Duration duration;
  late String endTime;
  late dynamic fare;
  late double walkDistance;

  Route.placeholder() {
    debugPrint("Route Placeholder");
  }

  Route({required Map<String, dynamic> json, required this.mapIndex}) {
    createDuration(json['duration'], json['transitTime'], json['waitingTime'],
        json['walkTime']);

    endTime = (json['endTime'].toString());
    fare = json['fare'];
    walkDistance = json['walkDistance'];
    legs = parseLegs(json['legs']);

    // debugging
    debugPrint(
        "Routeobject $mapIndex: Duration: ${duration.totalDuration},TransitTime: ${duration.transitTime}, WaitingTime: ${duration.waitingTime}, WalkingTime: ${duration.walkingTime} ,endTime: $endTime,fare: $fare,walk: $walkDistance");
  }

  void createDuration(int totalDurationInSeconds, int transitTime,
      int waitingTime, int walkingTime) {
    duration = Duration(
        totalDuration: totalDurationInSeconds,
        transitTime: transitTime,
        waitingTime: waitingTime,
        walkingTime: walkingTime);
  }

  List<Leg> parseLegs(List<dynamic> legs) {
    List<Leg> parsedLegs = [];

    for (Map<String, dynamic> leg_data in legs) {
      Leg leg = Leg.create(leg_data, leg_data['mode']);
      parsedLegs.add(leg);
    }

    return parsedLegs;
  }
}
