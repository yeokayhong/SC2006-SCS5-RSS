import 'location_entity.dart';

class Step extends Location {
  late String absoluteDirection;
  late double distance;

  Step(
      {required this.absoluteDirection,
      required this.distance,
      required double lat,
      required double lon,
      required String name})
      : super(lat: lat, lon: lon, name: name);
}
