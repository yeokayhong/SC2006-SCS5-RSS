import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scheduler_app/entities/step_entity.dart' as s;
import 'package:scheduler_app/entities/stop_entity.dart';
import 'package:scheduler_app/widgets/bus_leg.dart';
import 'package:scheduler_app/widgets/legs_widget_methods.dart';
import 'package:scheduler_app/widgets/walk_leg.dart';

abstract class LegType {
  String mode = "";
  int? waitingTime;
  Widget createLeg();
  String getMode() {
    return mode;
  }
}

class WalkLeg extends LegType {
  List<s.Step> steps = [];
  WalkLeg({required Map<String, dynamic> json}) {
    super.mode = "WALK";
    // intialize step list
    List<dynamic> stepsJson = json['steps'];
    // debug message
    debugPrint("StepsJson obtained: ${stepsJson.toString()}");
    for (var step in stepsJson) {
      steps.add(s.Step(
          absoluteDirection: step['absoluteDirection'],
          distance: step['distance'],
          lat: step['lat'],
          lon: step['lon'],
          name: step['streetName']));
    }
    debugPrint("Successful Created Steps: ${steps.length}");
  }

  @override
  Widget createLeg() {
    return WalkLegWidget(steps: steps);
  }
}

class BusLeg extends LegType {
  List<Stop> stops = [];
  BusLeg({required Map<String, dynamic> json}) {
    super.mode = "BUS";
    super.waitingTime = 0;
    // intialize stop list
    List<dynamic> stopsJson = json['intermediateStops'];
    // debug message
    debugPrint("StopsJson obtained: ${stopsJson.toString()}");

    for (var stop in stopsJson) {
      // create Stop
      stops.add(
        Stop(
          arrivalTime: stop['arrival'],
          departureTime: stop['departure'],
          lat: stop['lat'],
          lon: stop['lon'],
          name: stop['name'],
          stopCode: stop['stopCode'],
          stopIndex: stop['stopIndex'],
          stopSequence: stop['stopSequence'],
        ),
      );
    }
    debugPrint("Successful Created Stops: ${stops.length}");
  }

  @override
  Widget createLeg() {
    return TransitLegWidget(
      stops: stops,
      waitingTime: super.waitingTime,
    );
  }
}

class SubwayLeg extends LegType {
  Stop? from;
  Stop? to;
  List<Stop> stops = [];
  SubwayLeg({required Map<String, dynamic> json}) {
    super.mode = "SUBWAY";
    super.waitingTime = 0;
    // intialize stop list
    List<dynamic> unparsed = json['intermediateStops'];
    // debug message
    // initialize from
    dynamic fromJson = json['from'];
    debugPrint('from: $fromJson');
    if (fromJson['name'] != "Origin") {
      from = Stop(
          arrivalTime: fromJson['arrival'],
          departureTime: fromJson['departure'],
          lat: fromJson['lat'],
          lon: fromJson['lon'],
          name: fromJson['name'],
          stopCode: fromJson['stopCode'],
          stopIndex: fromJson['stopIndex'],
          stopSequence: fromJson['stopSequence']);
      // initialize from
      debugPrint('fromStop: ${from!.stopCode}');
    }
    debugPrint("Entering to json...");
    dynamic toJson = json['to'];
    debugPrint('to: $toJson');
    if (toJson['name'] != "Destination") {
      to = Stop(
          arrivalTime: toJson['arrival'],
          departureTime: -1,
          lat: toJson['lat'],
          lon: toJson['lon'],
          name: toJson['name'],
          stopCode: toJson['stopCode'],
          stopIndex: toJson['stopIndex'],
          stopSequence: toJson['stopSequence']);
      debugPrint('toStop: ${to!.stopCode}');
    }
    debugPrint("Parsing intermediate Stops...");

    for (var stop in unparsed) {
      // create Stop
      stops.add(Stop(
          arrivalTime: stop['arrival'],
          departureTime: stop['departure'],
          lat: stop['lat'],
          lon: stop['lon'],
          name: stop['name'],
          stopCode: stop['stopCode'],
          stopIndex: stop['stopIndex'],
          stopSequence: stop['stopSequence']));
    }
  }

  @override
  Widget createLeg() {
    return TransitLegWidget(stops: stops, waitingTime: super.waitingTime);
  }
}

class TramLeg extends LegType {
  Stop? from;
  Stop? to;
  List<Stop> stops = [];
  TramLeg({required Map<String, dynamic> json}) {
    super.mode = "TRAM";
    super.waitingTime = 0;
    // intialize stop list
    List<dynamic> unparsed = json['intermediateStops'];
    // debug message
    // initialize from
    dynamic fromJson = json['from'];
    debugPrint('from: $fromJson');
    if (fromJson['name'] != "Origin") {
      from = Stop(
          arrivalTime: fromJson['arrival'],
          departureTime: fromJson['departure'],
          lat: fromJson['lat'],
          lon: fromJson['lon'],
          name: fromJson['name'],
          stopCode: fromJson['stopCode'],
          stopIndex: fromJson['stopIndex'],
          stopSequence: fromJson['stopSequence']);
      // initialize from
      debugPrint('fromStop: ${from!.stopCode}');
    }
    debugPrint("Entering to json...");
    dynamic toJson = json['to'];
    debugPrint('to: $toJson');
    if (toJson['name'] != "Destination") {
      to = Stop(
          arrivalTime: toJson['arrival'],
          departureTime: -1,
          lat: toJson['lat'],
          lon: toJson['lon'],
          name: toJson['name'],
          stopCode: toJson['stopCode'],
          stopIndex: toJson['stopIndex'],
          stopSequence: toJson['stopSequence']);
      debugPrint('toStop: ${to!.stopCode}');
    }
    debugPrint("Parsing intermediate Stops...");

    for (var stop in unparsed) {
      // create Stop
      stops.add(Stop(
          arrivalTime: stop['arrival'],
          departureTime: stop['departure'],
          lat: stop['lat'],
          lon: stop['lon'],
          name: stop['name'],
          stopCode: stop['stopCode'],
          stopIndex: stop['stopIndex'],
          stopSequence: stop['stopSequence']));
    }
  }

  @override
  Widget createLeg() {
    return TransitLegWidget(stops: stops, waitingTime: super.waitingTime);
  }
}

// create a LegConstructor Type
typedef LegConstructor = LegType Function(Map<String, dynamic> arg);

class LegFactory {
  static final Map<String, LegConstructor> _registry = {};

  static void register(String mode, LegConstructor constructor) {
    _registry[mode] = constructor;
  }

  static LegType createLegType(String mode, Map<String, dynamic> json) {
    final constructor = _registry[mode];
    if (constructor != null) {
      return constructor(json);
    } else {
      throw Exception('Invalid Leg Mode: $mode');
    }
  }
}
