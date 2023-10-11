//import 'package:scheduler_app/entities/route_entity.dart';
//import 'package:scheduler_app/entities/concern_entity.dart';
//import 'package:scheduler_app/managers/concern_manager.dart';
//import 'package:scheduler_app/base_classes/notification_enum.dart';

class Notification {
  final String message;  
  final DateTime time;
  // NotificationEnum type;
  // Route route;
  // Concern concern;

  Notification(
    {required this.message,
    required this.time,
    /*required this.type,
    required this.route,
    required this.concern*/});
}
