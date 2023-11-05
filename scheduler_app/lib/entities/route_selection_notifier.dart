import 'package:scheduler_app/entities/route.dart' as route_entity;
import 'package:flutter/material.dart';

class RouteSelectionNotifier with ChangeNotifier {
  Map<int, route_entity.Route>? _routes;
  route_entity.Route? _selectedRoute;
  route_entity.Route? _activeRoute;

  Map<int, route_entity.Route>? get routes => _routes;
  route_entity.Route? get selectedRoute => _selectedRoute;
  route_entity.Route? get activeRoute => _activeRoute;

  set routes(Map<int, route_entity.Route>? newRoutes) {
    _routes = newRoutes;
    notifyListeners();
  }

  set selectedRoute(route_entity.Route? newSelectedRoute) {
    _selectedRoute = newSelectedRoute;
    notifyListeners();
  }

  set activeRoute(route_entity.Route? newActiveRoute) {
    _activeRoute = newActiveRoute;
    notifyListeners();
  }
}
