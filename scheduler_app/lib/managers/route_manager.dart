import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:scheduler_app/APIs/routes_api.dart';
import 'package:scheduler_app/entities/route_entity.dart' as r;

// RouteManager contains a class of methods for retrieving information on the retrieved Route Objects
class RouteManager {
  final Map<int, r.Route> _routeDict = {};
  EventBus get eventBus => GetIt.instance<EventBus>();

  RouteManager() {
    eventBus.on<RouteEvent>().listen((event) {
      fetchData(event.origin, event.dest, event.routeType);
      debugPrint(
          "Received: ${event.origin}, ${event.dest}, ${event.routeType}");
    });
  }

  // for debugging purposes
  Future<void> fetchData(String start, String end, String routeType) async {
    // get Current Date and Time
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MM-dd-yyyy').format(now);
    String formattedTime = DateFormat('HH:mm:ss').format(now);
    debugPrint("Date: ${formattedDate}Time: $formattedTime");
    Map<String, dynamic> json = await RoutesAPI.getRoutesPT(
        start: start,
        end: end,
        routeType: routeType,
        date: formattedDate,
        time: formattedTime);
    debugPrint("Data Retrieved: $json");
  }

  r.Route? getRouteDetail(String routeId) {
    if (_routeDict.containsKey(routeId)) {
      return _routeDict[routeId];
    }
    throw 'Route not found!';
  }

// Monitor potential concerns
  void monitorPotentialConcern() {
    // Implement your logic to monitor potential concerns here
  }

  // Get waiting time
  double getWaitingTime(String routeId) {
    if (_routeDict.containsKey(routeId)) {
      // Replace this with your logic to calculate waiting time
      return 10.0; // Example waiting time
    }
    throw 'Route not found!';
  }

  // Recalculate arrival time
  double recalculateArrivalTime(String routeId) {
    if (_routeDict.containsKey(routeId)) {
      // Replace this with your logic to recalculate arrival time
      return 20.0; // Example recalculated arrival time
    }
    throw 'Route not found!';
  }

// create Route Object and add to dictionary
  void createRoute(Map<String, dynamic> itinerary, int index) {
    r.Route newRoute = r.Route();
    // updateRouteDict(index, newRoute);
  }
}

class RouteEvent {
  final String origin;
  final String dest;
  final String routeType;

  RouteEvent(this.origin, this.dest, this.routeType);
}
