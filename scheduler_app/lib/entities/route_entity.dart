import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'duration.dart' as D;
import 'package:scheduler_app/entities/location_entity.dart' as l;

import 'leg_entity.dart';

class Route {
  late int mapIndex;
  List<Leg> legs = [];
  late List<LatLng> decodedLegGoemetry;
  late D.Duration duration;
  late String endTime;
  late dynamic fare;
  late double walkDistance;
  late l.Location from;
  late l.Location dest;

  Route({required Map<String, dynamic> json, required this.mapIndex}) {
    createDuration(json['duration'], json['transitTime'], json['waitingTime'],
        json['walkTime']);

    // get endTime in h:mm a format
    endTime = (json['endTime'].toString());

    // fare
    fare = json['fare'];

    // walkDistance
    walkDistance = json['walkDistance'];

    // create Legs
    createLegs(json['legs']);

    // get the from and dest from legList
    if (legs.isNotEmpty) {
      from = legs[0].start;
      dest = legs[legs.length - 1].dest;
    } else {
      throw "Legs are empty, something unexpected happened";
    }

    // debugging
    debugPrint(
        "Routeobject $mapIndex: Duration: ${duration.totalDuration},TransitTime: ${duration.transitTime}, WaitingTime: ${duration.waitingTime}, WalkingTime: ${duration.walkingTime} ,endTime: $endTime,fare: $fare,walk: $walkDistance");
  }

  void createDuration(int totalDurationInSeconds, int transitTime,
      int waitingTime, int walkingTime) {
    duration = D.Duration(
        totalDuration: totalDurationInSeconds,
        transitTime: transitTime,
        waitingTime: waitingTime,
        walkingTime: walkingTime);
  }

  void createLegs(List<dynamic> legs) {
    for (var entry in legs) {
      Leg newLeg = Leg(entry);
      this.legs.add(newLeg);
    }
  }
}
