import 'package:flutter/rendering.dart';
import 'package:scheduler_app/entities/step_entity.dart';
import 'package:scheduler_app/entities/stop_entity.dart';

// create new Legs here
enum LegMode {
  WALK,
  BUS,
  SUBWAY,
}

abstract class LegType {
  late LegMode mode;
}

class WalkLeg extends LegType {
  late List<Step> steps;
  WalkLeg({required Map<String, dynamic> json}) {
    super.mode = LegMode.WALK;
    // intialize step list
    List<dynamic> stepsJson = json['steps'];
    // debug message
    debugPrint(stepsJson.toString());
    for (var step in stepsJson) {
      steps.add(Step(
          absoluteDirection: step['absoluteDirection'],
          distance: step['distance'],
          lat: step['lat'],
          lon: step['lon'],
          name: step['name']));
    }
  }
}

class BusLeg extends LegType {
  late List<Stop> stops;
  BusLeg({required Map<String, dynamic> json}) {
    super.mode = LegMode.BUS;
    // intialize stop list
    List<dynamic> stopsJson = json['intermediateStops'];
    // debug message
    debugPrint(stopsJson.toString());
    for (var stop in stopsJson) {
      // create Stop
      stops.add(Stop(
          arrivalTime: stop['arrival'],
          departureTime: stop['lat'],
          lat: stop['lat'],
          lon: stop['lon'],
          name: stop['name'],
          stopCode: stop['stopCode'],
          stopIndex: stop['stopIndex'],
          stopSequence: stop['stopSequence']));
    }
  }
}

class SubwayLeg extends LegType {
  late List<Stop> stops;
  SubwayLeg({required Map<String, dynamic> json}) {
    super.mode = LegMode.SUBWAY;
    // intialize stop list
    List<dynamic> unparsed = json['intermediateStops'];
    // debug message
    debugPrint(unparsed.toString());
    for (var stop in unparsed) {
      // create Stop
      stops.add(Stop(
          arrivalTime: stop['arrival'],
          departureTime: stop['lat'],
          lat: stop['lat'],
          lon: stop['lon'],
          name: stop['name'],
          stopCode: stop['stopCode'],
          stopIndex: stop['stopIndex'],
          stopSequence: stop['stopSequence']));
    }
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
      throw Exception('Invalid Leg Mode');
    }
  }
}
