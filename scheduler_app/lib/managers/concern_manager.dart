import 'package:scheduler_app/managers/notification_manager.dart';
import "package:universal_html/html.dart" as html;
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

class ConcernManager {
  final NotificationManager _notificationManager =
      GetIt.instance<NotificationManager>();
  final html.EventSource _concernEvents =
      html.EventSource("http://10.0.2.2:5000/concerns/subscribe");

  ConcernManager() {
    _concernEvents.onMessage.listen((html.MessageEvent event) {
      print(event.data);
    });
    _concernEvents.addEventListener("add", (html.Event event) {
      _handleAddedConcern(event);
    });
    _concernEvents.addEventListener("update", (html.Event event) {
      _handleUpdatedConcern(event);
    });
    _concernEvents.addEventListener("remove", (html.Event event) {
      _handleRemovedConcern(event);
    });
  }

  void _handleAddedConcern(html.Event event) {
    if (!isActiveRouteAffected()) return;
    String title = "Concern added";
    String body = "A new concern has been added";
    _notificationManager.createNotification(title: title, body: body);
  }

  void _handleUpdatedConcern(html.Event event) {
    if (!isActiveRouteAffected()) return;
    String title = "Concern updated";
    String body = "A concern has been updated";
    _notificationManager.createNotification(title: title, body: body);
  }

  void _handleRemovedConcern(html.Event event) {
    if (!isActiveRouteAffected()) return;
    String title = "Concern removed";
    String body = "A concern has been removed";
    _notificationManager.createNotification(title: title, body: body);
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

  bool isActiveRouteAffected() {
    return true;
  }

  void dispose() {
    _concernEvents.close();
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
