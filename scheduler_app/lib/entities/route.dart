import 'package:scheduler_app/entities/address.dart';
import 'package:scheduler_app/entities/stop.dart';
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
  final Address origin;
  final Address destination;

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

    for (Map<String, dynamic> leg_data in legs) {
      Leg leg = Leg.create(leg_data, leg_data['mode']);
      parsedLegs.add(leg);
    }

    return parsedLegs;
  }
}
