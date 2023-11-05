import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scheduler_app/entities/stop_entity.dart';
import '../managers/concern_manager.dart';
import 'duration.dart' as D;
import 'package:scheduler_app/entities/location_entity.dart' as l;

import 'leg_entity.dart';
import 'legtype_entity.dart';

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
  int additionalTime = 0;
  List<Concern> concerns = [];
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

  void recalculateTime() {
    for (var concern in concerns) {
      if (concern.getAdditionalTime() != null) {
        additionalTime += concern.getAdditionalTime()!;
      }
    }
    debugPrint("AdditionalTime: $additionalTime");
  }

  bool isAffectedByConcern(Concern concern) {
    for (var leg in legs) {
      debugPrint("LegMode in searchAffectedRoutes: ${leg.legType.getMode()}");
      if (leg.legType.getMode() == "SUBWAY") {
        // check from and to
        SubwayLeg subwayLeg = leg.legType as SubwayLeg;
        List<Stop> stops = subwayLeg.stops;
        if (subwayLeg.from != null) {
          stops.add(subwayLeg.from as Stop);
        }

        if (subwayLeg.to != null) {
          stops.add(subwayLeg.to as Stop);
        }

        List<String> affectedStops = concern.affectedStops;
        for (var stop in stops) {
          for (var stopCode in affectedStops) {
            debugPrint(
                "StopCode vs affectedStops: ${stop.stopCode} vs $stopCode");
            if (stop.stopCode == stopCode) {
              debugPrint("Route is affected by Concern!");
              debugPrint('Added Concern!');
              return true;
            }
          }
        }
      }
    }
    return false;
  }

  bool isThereConcern() {
    return concerns.isNotEmpty;
  }
}
