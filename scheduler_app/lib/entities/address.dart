import 'package:scheduler_app/managers/concern_manager.dart';
import 'dart:math';

class Address {
  final String full_address;
  final building_name;
  final String postal_code;
  final double latitude;
  final double longitude;

  Address({
    required this.full_address,
    required this.latitude,
    required this.longitude,
    required this.postal_code,
    required String building_name,
  }) : this.building_name = toTitleCase(building_name);

  static String toTitleCase(input) {
    return input
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  double distance(double userLat, double userLong) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((userLat - latitude) * p) / 2 +
        c(latitude * p) *
            c(userLat * p) *
            (1 - c((userLong - longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  String street_address() {
    return full_address
        .replaceAll(postal_code, '')
        .replaceAll("SINGAPORE", '')
        .trim();
  }
}
