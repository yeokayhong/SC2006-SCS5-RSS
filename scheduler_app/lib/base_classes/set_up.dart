import 'package:event_bus/event_bus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:scheduler_app/managers/notification_manager.dart';
import 'package:scheduler_app/managers/route_manager.dart';

GetIt getIt = GetIt.instance;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> instanceSetUp() async {
  getIt.registerSingleton<EventBus>(EventBus());
  getIt.registerSingleton<NotificationManager>(
      NotificationManager.getInstance());
  getIt.registerSingleton<RouteManager>(RouteManager());
  await NotificationManager.initializeNotifications(
      flutterLocalNotificationsPlugin);
  getIt.registerSingleton<FlutterLocalNotificationsPlugin>(
      flutterLocalNotificationsPlugin);
}
