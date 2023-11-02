import 'location_entity.dart';

class Stop extends Location {
  late int arrivalTime;
  late int departureTime;
  late String stopCode;
  late int stopIndex;
  late int stopSequence;
  int waitingTime = 0;

  Stop({
    required this.arrivalTime,
    required this.departureTime,
    required this.stopCode,
    required this.stopIndex,
    required this.stopSequence,
    required double lat,
    required double lon,
    required String name,
  }) : super(lat: lat, lon: lon, name: name) {
    waitingTime = ((departureTime - arrivalTime) / (1000 * 60)).round();
  }
}
