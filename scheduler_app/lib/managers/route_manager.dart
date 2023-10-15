import 'package:flutter/material.dart';
import 'package:scheduler_app/APIs/onemap_api.dart';
import 'package:scheduler_app/entities/route_entity.dart' as r;

// RouteManager contains a class of methods for retrieving information on the retrieved Route Objects
class RouteManager {
  final Map<int, r.Route> _routeDict = {};

  // request parameters filled up by UI
  final Map<String, String> _requestParameters = {};

  // Method to update the map using the setter
  void updateRequestParameters(String key, String value) {
    _requestParameters[key] = value;
  }

  void updateRouteDict(int key, r.Route value) {
    _routeDict[key] = value;
  }

  void getRoutesFromOneMap() async {
    final String accessToken;
    final Map<String, dynamic> response;
    try {
      accessToken = await OneMapAPI.fetchToken();
      response = await OneMapAPI.getRoutesPT(
          accessToken: accessToken,
          start: _requestParameters["start"] ?? "",
          end: _requestParameters["end"] ?? "",
          routeType: _requestParameters["routeType"] ?? "pt",
          date: _requestParameters["date"] ?? "",
          time: _requestParameters["time"] ?? "",
          mode: _requestParameters["mode"] ?? "TRANSIT,BUS,RAIL",
          maxWalkDistance: _requestParameters["maxWalkDistance"] ?? "1000",
          numItineraries: _requestParameters["numItineraries"] ?? "1");
    } catch (e) {
      debugPrint(e.toString());
    }

    // TODO: Loop through response, and create each Route object using the createRoute method.
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

// Get estimated waiting time
  // Future<double> getEstimatedWaitingTime(String busStopCode, String serviceNo) async {
  //   try {
  //     final estimatedTime = await LtaApi.getEstimatedWaitingTime(
  //       busStopCode: busStopCode,
  //       serviceNo: serviceNo,
  //     );
  //     return estimatedTime.toDouble();
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return 0.0;
  //   }
  // }

// create Route Object and add to dictionary
  void createRoute(Map<String, dynamic> itinerary, int index) {
    r.Route newRoute = r.Route();
    updateRouteDict(index, newRoute);
  }
}
