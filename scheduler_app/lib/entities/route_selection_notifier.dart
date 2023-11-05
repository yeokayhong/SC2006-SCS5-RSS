import 'package:scheduler_app/entities/route.dart' as route_entity;
import 'package:scheduler_app/entities/address.dart';
import 'package:flutter/material.dart';

class RouteSelectionNotifier with ChangeNotifier {
  Address? _origin;
  Address? _destination;
  route_entity.Route? _route;

  Address? get origin => _origin;
  Address? get destination => _destination;
  route_entity.Route? get route => _route;

  set origin(Address? newOrigin) {
    _origin = newOrigin;
    notifyListeners();
  }

  set destination(Address? newDestination) {
    _destination = newDestination;
    notifyListeners();
  }

  set route(route_entity.Route? newRoute) {
    _route = newRoute;
    notifyListeners();
  }
}
