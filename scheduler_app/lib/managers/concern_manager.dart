import 'package:scheduler_app/managers/notification_manager.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

class ConcernManager {
  ConcernManager() {
    final NoficiationManger _notificationManager = GetIt.instance<NotificationManager>();
    final html.EventSource concernEvents = http.EventSource(Uri.parse("/concerns/events"));
    concernEvents.addEventListener("added", (html.Event event) {
      _handleAddedConcern(event)
    });
    concernEvents.addEventListener("updated", (html.Event event) {
      _handleUpdatedConcern(event)
    });
  }

  void _handleAddedConcern(html.Event event) {
    if (!isActiveRouteAffected()) return
    _notificationManager.displayRealTimeNotification("Train delay along...", "Please click to display alternatives");
  }

  void _handleUpdatedConcern(html.Event event) {
    if (!isActiveRouteAffected()) return
    _notificationManager.displayRealTimeNotification("Updates to train delay along...", "Please click to display alternatives");
  }

  List<Concern> getConcerns() {
    http.Response response = await http.get(Uri.parse("/concerns"));
    if (response.statusCode != 200) {
      throw Exception("Failed to get concerns");
    }
    List<Concern> concerns = [];
    for (var concern in response.body) {
      concerns.add(Concern(
        type: concern["type"],
        service: concern["service"],
        affectedStops: concern["affectedStops"],
        time: concern["time"],
        message: concern["message"],
      ));
    }

    return concerns;
  }

  bool isActiveRouteAffected() {
    return false;
  }

  void dispose() {
    this.concernEvents.close();
  }
}

class Concern {
  String type;
  String service;
  List<String> affectedStops;
  DateTime time;
  String message;

  Concern(
      {required this.type,
      required this.service,
      required this.affectedStops,
      required this.time,
      required this.message});

  @override
  bool operator ==(Object other) {
    if (other is! Concern) {
      return false;
    }
    return type == other.type && service == other.service && time == other.time;
  }

  @override
  int get hashCode => type.hashCode ^ service.hashCode ^ time.hashCode;
}
