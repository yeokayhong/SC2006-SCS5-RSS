import 'package:scheduler_app/managers/concern_manager.dart';
import 'package:scheduler_app/entities/address.dart';
import 'package:scheduler_app/entities/stop.dart';
import 'package:flutter/material.dart';
import 'duration.dart';
import 'leg.dart';

class Route {
  final int mapIndex;
  final List<Leg> legs;
  final Duration duration;
  final String endTime;
  final dynamic fare;
  final double walkDistance;
  Stop? currentStop;
  Leg? currentLeg;
  final Address origin;
  final Address destination;
  List<Concern> concerns = [];
  int additionalTime = 0;

  Route({
    required this.mapIndex,
    required this.legs,
    required this.duration,
    required this.endTime,
    required this.fare,
    required this.walkDistance,
    this.currentStop,
    required this.origin,
    required this.destination,
  });

  static Route fromJson(Map<String, dynamic> json, int mapIndex, Address origin,
      Address destination) {
    return Route(
      mapIndex: mapIndex,
      legs: parseLegs(json['legs']),
      duration: parseDuration(json['duration'], json['transitTime'],
          json['waitingTime'], json['walkTime']),
      endTime: json['endTime'].toString(),
      fare: json['fare'],
      walkDistance: json['walkDistance'],
      origin: origin,
      destination: destination,
    );
  }

  static Duration parseDuration(int totalDurationInSeconds, int transitTime,
      int waitingTime, int walkingTime) {
    return Duration(
        totalDuration: totalDurationInSeconds,
        transitTime: transitTime,
        waitingTime: waitingTime,
        walkingTime: walkingTime);
  }

  static List<Leg> parseLegs(List<dynamic> legs) {
    List<Leg> parsedLegs = [];

    for (Map<String, dynamic> legData in legs) {
      Leg leg = LegFactory.fromJson(legData, legData['mode']);
      parsedLegs.add(leg);
    }

    return parsedLegs;
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
    for (Leg leg in legs) {
      if (leg.runtimeType == RailLeg) {
        List<Stop> stops = leg.allStops;
        List<String> affectedStops = concern.affectedStops;
        for (Stop stop in stops) {
          if (stop is! RailStop) {
            throw Exception("Stop in RailLeg is not RailStop");
          }
          for (String stopCode in affectedStops) {
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
