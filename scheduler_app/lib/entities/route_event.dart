import 'package:scheduler_app/entities/address.dart';

class RouteEvent {
  final Address origin;
  final Address destination;
  final String routeType;

  RouteEvent(
      {required this.origin, required this.destination, this.routeType = "pt"});
}
