import 'dart:math';

import 'package:scheduler_app/entities/route.dart' as route_entity;
import 'package:scheduler_app/base_classes/geolocator.dart';
import 'package:scheduler_app/APIs/routes_api.dart';
import 'package:scheduler_app/entities/stop.dart';
import 'package:scheduler_app/entities/leg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import '../entities/route_event.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import '../entities/address.dart';
import 'concern_manager.dart';
import 'dart:async';

// RouteManager contains a class of methods for retrieving information on the retrieved Route Objects
class RouteManager {
  final StreamController<Map<int, route_entity.Route>> _routeStreamController =
      StreamController<Map<int, route_entity.Route>>.broadcast();
  EventBus get eventBus => GetIt.instance<EventBus>();
  final Map<int, route_entity.Route> _routeDict = {};
  final double stopDetectionRadiusMeters = 50;
  route_entity.Route? _activeRoute;
  Timer? _activeRouteUpdateTimer;
  final _activeRouteUpdateInterval = const Duration(seconds: 5);

  RouteManager() {
    // initialize Stream to look at the _routeDict
    _routeStreamController.add(_routeDict);
    eventBus.on<RouteEvent>().listen((event) async {
      Map<String, dynamic> json =
          await fetchData(event.origin, event.dest, event.routeType);
      debugPrint(
          "Received: ${event.origin}, ${event.dest}, ${event.routeType}");
      if (json["error"] == "")
        createRoutes(json['plan']['itineraries']);
      else {
        debugPrint(json['error']);
      }
    });
  }

  Future<Stop?> getCurrentStopAlongRoute(route_entity.Route route) async {
    Stop? nearestStop;

    int numLegs = route.legs.length;
    if (numLegs == 0) return null;
    int randomLeg = Random().nextInt(numLegs);
    int numStops = route.legs[randomLeg].stops.length;
    if (numStops == 0) return null;
    int randomStop = Random().nextInt(numStops);
    nearestStop = route.legs[randomLeg].stops[randomStop];

    // Position currentPosition = await requestLocation();
    // double minDistance = double.infinity;
    // for (Leg leg in route.legs) {
    //   for (Stop stop in leg.stops) {
    //     double distance = Geolocator.distanceBetween(stop.lat, stop.lon,
    //         currentPosition.latitude, currentPosition.longitude);
    //     if (distance < minDistance) {
    //       minDistance = distance;
    //       nearestStop = stop;
    //     }
    //   }
    // }

    // if (minDistance > stopDetectionRadiusMeters) {
    //   throw Exception("No stops within $stopDetectionRadiusMeters meters");
    // }

    return nearestStop;
  }

  void updatePositionAlongRoute(route_entity.Route route) async {
    try {
      Stop? newCurrentStop = await getCurrentStopAlongRoute(route);
      if (newCurrentStop != null) {
        if (route.currentStop != null) {
          route.currentStop!.isCurrentStop = false;
          print("Previous Stop: ${route.currentStop!.name}");
        }
        newCurrentStop.isCurrentStop = true;
        route.currentStop = newCurrentStop;
        print("New Stop: ${route.currentStop!.name}");
        updateSingleRoute(route.mapIndex, route);
      }
    } catch (exception) {
      if (exception is! Exception) rethrow;
      if (!exception.toString().contains("No stops within")) rethrow;
    }
  }

  void setActiveRoute(route_entity.Route route) {
    _activeRoute = route;
    _activeRouteUpdateTimer?.cancel();
    _activeRouteUpdateTimer =
        Timer.periodic(_activeRouteUpdateInterval, (timer) {
      updatePositionAlongRoute(route);
    });
    print("Active Route: $_activeRoute");
  }

  // for debugging purposes
  Future<Map<String, dynamic>> fetchData(
      String start, String end, String routeType) async {
    // get Current Date and Time
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MM-dd-yyyy').format(now);
    String formattedTime = DateFormat('HH:mm:ss').format(now);
    debugPrint("Date: ${formattedDate}Time: $formattedTime");
    Map<String, dynamic> json = await RoutesAPI.getRoutes(
        start: start,
        end: end,
        routeType: routeType,
        date: formattedDate,
        time: formattedTime);
    debugPrint("Data Retrieved: $json");
    return json;
  }

  route_entity.Route getRoute(int routeId) {
    if (_routeDict.containsKey(routeId)) {
      return _routeDict[routeId]!;
    }
    throw 'Route not found!';
  }

  // // search affected Routes and update them
  // void searchAffectedRoutes(Concern concern) {}

  // // search affected Routes with entire concernList
  // void searchAffectedRoutesWithConcernList(List<Concern> concernList) {}

  // get Bus Waiting Time
  void getBusWaitingTime() {
    // update Routes into Stream
    _routeStreamController.add(_routeDict);
  }

  // get MRT Waiting Time
  void getMRTWaitingTime() {
    // update Routes into Stream
    _routeStreamController.add(_routeDict);
  }

  // update Route Arrival Time inclusive of live Waiting Time
  void updateLiveArrivalTime() {}

  // create Route Object and add to dictionary, json should be of json['itineraries]
  void createRoutes(List<dynamic> json) {
    // remove previous route data, since new origin and destination are chosen
    _routeDict.clear();
    int counter = 1;
    for (var route in json) {
      route_entity.Route newRoute =
          route_entity.Route(json: route, mapIndex: counter);
      _routeDict[counter] = newRoute;
      counter++;
    }
    debugPrint("Routes: $_routeDict");

    // update Routes into Stream
    _routeStreamController.add(_routeDict);
    debugPrint("Event emitted: $_routeDict");
  }

  static String formatEndTime(
      {required String endTimeInUnix, int offset = 28800000}) {
    // endTime is in Unix TimeStamp
    debugPrint(endTimeInUnix);
    DateTime result = DateTime.fromMillisecondsSinceEpoch(
        int.parse(endTimeInUnix),
        isUtc: true);

    result = result.add(
      Duration(milliseconds: offset),
    );
    debugPrint(result.toString());
    // convert time eg. display in 9:30 pm
    return DateFormat('h:mm a').format(result);
  }

  void updateSingleRoute(int routeNumber, route_entity.Route newRoute) {
    _routeDict[routeNumber] = newRoute;
    _routeStreamController.add(_routeDict);
  }

  // Stream Map<object>
  Stream<Map<int, route_entity.Route>> get routeStream =>
      _routeStreamController.stream;
}
