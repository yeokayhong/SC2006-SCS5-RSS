import 'package:scheduler_app/constants.dart';
import 'package:scheduler_app/managers/notification_manager.dart';
import 'package:scheduler_app/managers/route_manager.dart';
import "package:universal_html/html.dart" as html;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'dart:convert';

import '../screens/notifications_history.dart';

class ConcernManager {
  final NotificationManager _notificationManager =
      GetIt.instance<NotificationManager>();
  final html.EventSource _concernEvents =
      html.EventSource(Constants.serverConcernRequest);
  final RouteManager _routeManager = GetIt.instance<RouteManager>();

  ConcernManager() {
    _concernEvents.addEventListener("add", (html.Event event) {
      _routeManager.calculateAffectedRoutes();
      _handleAddedConcern(event);
    });
    _concernEvents.addEventListener("update", (html.Event event) {
      _routeManager.calculateAffectedRoutes();
      _handleUpdatedConcern(event);
    });
    _concernEvents.addEventListener("remove", (html.Event event) {
      _routeManager.calculateAffectedRoutes();
      _handleRemovedConcern(event);
    });
  }

  void _handleAddedConcern(html.Event event) {
    if (!isActiveRouteAffected()) return;
    String message = (event as html.MessageEvent).data as String;
    Map<String, dynamic> json = jsonDecode(message);
    _notificationManager.createNotification(
      title: json["message"],
      body: "There is a new alert along your route",
      // payload: {
      //   "type": json["type"],
      //   "service": json["service"],
      //   "affectedStops": json["affected_stops"],
      //   "time": json["time"],
      //   "message": json["message"]
      // }
    );
    GetIt.instance<NotificationUI>().callUpdateNotificationList();
  }

  void _handleUpdatedConcern(html.Event event) {
    if (!isActiveRouteAffected()) return;
    String message = (event as html.MessageEvent).data as String;
    Map<String, dynamic> json = jsonDecode(message);

    _notificationManager.createNotification(
      title: json["message"],
      body: "An alert along your route has updates",
      // payload: {
      //   "type": json["type"],
      //   "service": json["service"],
      //   "affectedStops": json["affected_stops"],
      //   "time": json["time"],
      //   "message": json["message"]
      // }
    );
    GetIt.instance<NotificationUI>().callUpdateNotificationList();
  }

  void _handleRemovedConcern(html.Event event) {
    if (!isActiveRouteAffected()) return;
    String message = (event as html.MessageEvent).data as String;
    Map<String, dynamic> json = jsonDecode(message);

    _notificationManager.createNotification(
      title: json["message"],
      body: "This alert along your route has been removed",
      // payload: {
      //   "type": json["type"],
      //   "service": json["service"],
      //   "affectedStops": json["affected_stops"],
      //   "time": json["time"],
      //   "message": json["message"]
      // }
    );
    GetIt.instance<NotificationUI>().callUpdateNotificationList();
  }

  Future<List<Concern>> getConcerns() async {
    http.Response response = await http.get(Uri.parse("/concerns"));
    if (response.statusCode != 200) {
      throw Exception("Failed to get concerns");
    }

    List<Concern> concerns = [];
    for (var concern in response.body as List<dynamic>) {
      concerns.add(Concern(
          type: concern["type"],
          service: concern["service"],
          affectedStops: concern["affectedStops"],
          time: DateTime.parse(concern["time"]),
          message: concern["message"]));
    }

    return concerns;
  }

  // testGetConcern
  List<Concern> testGetConcerns() {
    List<Concern> concerns = [];
    concerns.add(Concern(
        type: "",
        service: "NEL",
        affectedStops: ["NE9", "NE8", "NE7", "NE6"],
        time: DateTime.now(),
        message:
            "0901hrs : NEL - Additional travelling time of 20 minutes between Boon Keng and Dhoby Ghuat stations towards HarbourFront station due to a signal fault."));
    return concerns;
  }

  bool isActiveRouteAffected() {
    return true;
  }

  void dispose() {
    _concernEvents.close();
  }
}

class Concern {
  final String type;
  final String service;
  final List<String> affectedStops;
  final DateTime time;
  final String message;

  Concern({
    required this.type,
    required this.service,
    required this.affectedStops,
    required this.time,
    required this.message,
  });

  @override
  bool operator ==(Object other) {
    if (other is! Concern) {
      return false;
    }
    return type == other.type &&
        service == other.service &&
        listEquals(affectedStops, other.affectedStops);
  }

  @override
  int get hashCode => type.hashCode ^ service.hashCode ^ affectedStops.hashCode;

  int? getAdditionalTime() {
    // obtain the time using regex
    RegExp regExp = RegExp(r'(\d+) minutes');
    RegExpMatch? match = regExp.firstMatch(message);
    String? matchedString = match?.group(1);
    int? delayMinutes = matchedString != null ? int.parse(matchedString) : null;
    debugPrint(
      delayMinutes.toString(),
    ); // This should print out the delay in minutes, e.g., 20.
    return delayMinutes;
  }
}
