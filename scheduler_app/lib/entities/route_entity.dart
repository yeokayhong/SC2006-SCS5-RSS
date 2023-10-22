import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'duration.dart' as D;

import 'leg_entity.dart';

class Route {
  late int mapIndex;
  List<Leg> legs = [];
  late List<LatLng> decodedLegGoemetry;
  late D.Duration duration;
  late String endTime;
  late double fare;
  late double walkDistance;

  Route.placeholder() {
    debugPrint("Route Placeholder");
  }

  Route({required Map<String, dynamic> json, required this.mapIndex}) {
    createDuration(json['duration'].toString(), json['transitTime'].toString(),
        json['waitingTime'].toString(), json['walkTime'].toString());

    // get endTime in h:mm a format
    formatEndTime(json['endTime'].toString());

    // fare
    fare = double.parse(json['fare'].toString());

    // walkDistance
    walkDistance = json['walkDistance'];

    // create Legs
    createLegs(json['legs']);

    // debugging
    debugPrint(
        "Routeobject $mapIndex: Duration: ${duration.totalDuration},TransitTime: ${duration.transitTime}, WaitingTime: ${duration.waitingTime}, WalkingTime: ${duration.walkingTime} ,endTime: $endTime,fare: $fare,walk: $walkDistance");
  }

  void createDuration(String totalDurationInSeconds, String transitTime,
      String waitingTime, String walkingTime) {
    duration = D.Duration(
        totalDuration: totalDurationInSeconds,
        transitTime: transitTime,
        waitingTime: waitingTime,
        walkingTime: walkingTime);
  }

  void formatEndTime(String endTimeInUnix) {
    // endTime is in Unix TimeStamp
    debugPrint(endTimeInUnix);
    DateTime result = DateTime.fromMillisecondsSinceEpoch(
        int.parse(endTimeInUnix),
        isUtc: true);
    result = result.add(const Duration(hours: 8));
    debugPrint(result.toString());
    // convert time eg. display in 9:30 pm
    endTime = DateFormat('h:mm a').format(result);
  }

  void createLegs(List<dynamic> legs) {
    for (var entry in legs) {
      Leg newLeg = Leg(entry);
      this.legs.add(newLeg);
    }
  }
}
