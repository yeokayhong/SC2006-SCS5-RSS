import 'location_entity.dart';

class Step extends Location {
  late String absoluteDirection;
  late dynamic distance;

  Step(
      {required this.absoluteDirection,
      required this.distance,
      required dynamic lat,
      required dynamic lon,
      required String name})
      : super(lat: lat, lon: lon, name: name);
}
