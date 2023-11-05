import 'package:scheduler_app/entities/route.dart' as route_entity;
import 'package:scheduler_app/managers/concern_manager.dart';
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
import 'dart:async';
import 'dart:math';

// RouteManager contains a class of methods for retrieving information on the retrieved Route Objects
class RouteManager {
  final StreamController<Map<int, route_entity.Route>> _routeStreamController =
      StreamController<Map<int, route_entity.Route>>.broadcast();
  EventBus get eventBus => GetIt.instance<EventBus>();
  final Map<int, route_entity.Route> _routeDict = {};
  final double stopDetectionRadiusMeters = 200;
  Timer? _activeRouteUpdateTimer;
  final _activeRouteUpdateInterval = const Duration(seconds: 5);
  route_entity.Route? _activeRoute;

  RouteManager() {
    // initialize Stream to look at the _routeDict
    _routeStreamController.add(_routeDict);

    eventBus.on<RouteQueryEvent>().listen((event) async {
      Map<String, dynamic> json =
          await fetchData(event.origin, event.destination, event.routeType);
      debugPrint(
          "Received: ${event.origin}, ${event.destination}, ${event.routeType}");
      if (json["error"] == "") {
        createRoutes(
            json['plan']['itineraries'], event.origin, event.destination);
      } else {
        debugPrint(json['error']);
      }
    });
  }

  Future<Stop?> getCurrentStopAlongRoute(route_entity.Route route) async {
    Stop? nearestStop;

    Position currentPosition = await requestLocation();
    double minDistance = double.infinity;
    for (Leg leg in route.legs) {
      for (Stop stop in leg.allStops) {
        double distance = Geolocator.distanceBetween(stop.lat, stop.lon,
            currentPosition.latitude, currentPosition.longitude);
        if (distance < minDistance) {
          minDistance = distance;
          nearestStop = stop;
        }
      }
    }

    print(currentPosition);
    print(nearestStop);
    print(minDistance);

    if (minDistance > stopDetectionRadiusMeters) {
      throw Exception("No stops within $stopDetectionRadiusMeters meters");
    }

    return nearestStop;
  }

  Leg? getLegOfStopAlongRoute(Stop stop, route_entity.Route route) {
    for (Leg leg in route.legs) {
      if (leg.allStops.contains(stop)) {
        return leg;
      }
    }
    return null;
  }

  void updatePositionAlongRoute(route_entity.Route route) async {
    try {
      Stop? newCurrentStop = await getCurrentStopAlongRoute(route);
      if (newCurrentStop != null) {
        Leg legOfStop = getLegOfStopAlongRoute(newCurrentStop, route)!;
        if (route.currentStop != null) {
          route.currentStop!.isCurrentStop = false;
          print("Previous Stop: ${route.currentStop!.name}");
        }
        if (route.currentLeg != null) {
          route.currentLeg!.isCurrentLeg = false;
          print("Previous Leg: ${route.currentLeg!.serviceName}");
        }
        newCurrentStop.isCurrentStop = true;
        legOfStop.isCurrentLeg = true;

        route.currentStop = newCurrentStop;
        route.currentLeg = legOfStop;

        print("New Stop: ${route.currentStop!.name}");
        print("New Leg: ${route.currentLeg!.serviceName}");
        updateSingleRoute(route.mapIndex, route);
      }
    } catch (exception) {
      if (exception is! Exception) rethrow;
      if (!exception.toString().contains("No stops within")) rethrow;
    }
  }

  void setActiveRoute(route_entity.Route? route) {
    if (route == null) {
      _activeRouteUpdateTimer?.cancel();
      _activeRoute = null;
      _routeStreamController.add(_routeDict);
      return;
    }

    _activeRoute = route;
    _activeRouteUpdateTimer?.cancel();
    updatePositionAlongRoute(route);
    _activeRouteUpdateTimer =
        Timer.periodic(_activeRouteUpdateInterval, (timer) {
      updatePositionAlongRoute(route);
    });
    print("Active Route: $_activeRoute");
  }

  void cancelTimers() {
    print("cancelling timer");
    _activeRouteUpdateTimer?.cancel();
  }

  route_entity.Route? getActiveRoute() {
    return _activeRoute;
  }

  // for debugging purposes
  Future<Map<String, dynamic>> fetchData(
      Address origin, Address destination, String routeType) async {
    String start = "${origin.latitude},${origin.longitude}";
    String end = "${destination.latitude},${destination.longitude}";
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

  // search affected Routes and update them
  void calculateAffectedRoutes() async {
    final ConcernManager _concernManager = GetIt.instance<ConcernManager>();
    // ACTUAL IMPLEMENTATION TO GET CONCERN
    // List<Concern> localConcernList = await _concernManager.getConcerns();

    // TEST IMPLEMENTATION
    List<Concern> localConcernList = _concernManager.testGetConcerns();
    debugPrint("Calculating Affected Routes");
    for (var route in _routeDict.values) {
      route.concerns.clear();
      debugPrint("Clear Concern list ${route.concerns}");
      for (var concern in localConcernList) {
        debugPrint("Checking each concern...");
        // check if it is affected by concern
        // if it is, add the necessary stuff
        if (route.isAffectedByConcern(concern)) {
          route.concerns.add(concern);
          debugPrint(
              "Route ${route.mapIndex} is affected by ${concern.affectedStops}");
        }
        // do my stuff
      }
      route.recalculateTime();
    }
    debugPrint("Calculated Affected Routes!");

    _routeStreamController.add(_routeDict);
  }

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
  void createRoutes(List<dynamic> json, Address origin, Address destination) {
    // remove previous route data, since new origin and destination are chosen
    _routeDict.clear();
    int counter = 1;
    for (var route in json) {
      route_entity.Route newRoute =
          route_entity.Route.fromJson(route, counter, origin, destination);
      _routeDict[counter] = newRoute;
      counter++;
    }
    debugPrint("Routes: $_routeDict");

    // update Routes into Stream
    _routeStreamController.add(_routeDict);
    debugPrint("Event emitted: $_routeDict");

    // test the affectedRoutes
    // GetIt.instance<RouteManager>().calculateAffectedRoutes();
  }

  static String formatEndTime(
      {required String endTimeInUnix, int offset = 28800000}) {
    // endTime is in Unix TimeStamp
    debugPrint(endTimeInUnix);
    DateTime result = DateTime.fromMillisecondsSinceEpoch(
        int.parse(endTimeInUnix),
        isUtc: false);

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
