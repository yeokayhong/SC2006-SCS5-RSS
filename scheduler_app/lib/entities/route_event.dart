import 'package:scheduler_app/entities/address.dart';

class RouteQueryEvent {
  final Address origin;
  final Address destination;
  final String routeType;

  RouteQueryEvent(
      {required this.origin, required this.destination, this.routeType = "pt"});
}
