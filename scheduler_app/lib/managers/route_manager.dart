import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:scheduler_app/APIs/routes_api.dart';
import 'package:scheduler_app/entities/route_entity.dart' as r;

import '../entities/route_event.dart';

// RouteManager contains a class of methods for retrieving information on the retrieved Route Objects
class RouteManager {
  final Map<int, r.Route> _routeDict = {};
  EventBus get eventBus => GetIt.instance<EventBus>();

  RouteManager() {
    eventBus.on<RouteEvent>().listen((event) async {
      Map<String, dynamic> json =
          await fetchData(event.origin, event.dest, event.routeType);
      debugPrint(
          "Received: ${event.origin}, ${event.dest}, ${event.routeType}");
      createRoutes(json['plan']['itineraries']);
    });
  }

  // for debugging purposes
  Future<Map<String, dynamic>> fetchData(
      String start, String end, String routeType) async {
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
    return json;
  }

  r.Route? getRouteDetail(String routeId) {
    if (_routeDict.containsKey(routeId)) {
      return _routeDict[routeId];
    }
    throw 'Route not found!';
  }

// search affected Routes
  void searchAffectedRoutes(String stringToCompare) {}

// create Route Object and add to dictionary, json should be of json['itineraries]
  void createRoutes(List<dynamic> json) {
    int counter = 1;
    for (var route in json) {
      r.Route newRoute = r.Route(json: route, mapIndex: counter);
      _routeDict[counter] = newRoute;
      counter++;
    }
    debugPrint("Routes: $_routeDict");
  }
}
