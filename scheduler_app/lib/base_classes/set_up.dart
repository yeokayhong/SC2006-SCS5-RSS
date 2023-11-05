import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:scheduler_app/base_classes/subway_service_color.dart';
import 'package:scheduler_app/managers/notification_manager.dart';
import 'package:scheduler_app/managers/concern_manager.dart';
import 'package:scheduler_app/managers/route_manager.dart';
import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';

import '../screens/notifications_history.dart';

GetIt getIt = GetIt.instance;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> instanceSetUp() async {
  // getIt
  getIt.registerSingleton<EventBus>(EventBus());

  getIt.registerSingleton<NotificationManager>(
      NotificationManager.getInstance());
  getIt.registerSingleton<RouteManager>(RouteManager());
  getIt.registerSingleton<ConcernManager>(ConcernManager());

  await NotificationManager.initializeNotifications(
      flutterLocalNotificationsPlugin);
  getIt.registerSingleton<FlutterLocalNotificationsPlugin>(
      flutterLocalNotificationsPlugin);

  getIt.registerSingleton<NotificationUI>(NotificationUI());
  SubwayServiceColor subwayServiceColor =
      await SubwayServiceColor.getInstance();
  getIt.registerSingleton<SubwayServiceColor>(subwayServiceColor);
}
