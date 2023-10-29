import 'package:event_bus/event_bus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:scheduler_app/managers/notification_manager.dart';
import 'package:scheduler_app/managers/concern_manager.dart';
import 'package:scheduler_app/managers/route_manager.dart';
import '../entities/legtype_entity.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> instanceSetUp() async {
  // getIt
  getIt.registerSingleton<EventBus>(EventBus());
  getIt.registerSingleton<NotificationManager>(
      NotificationManager.getInstance());
  getIt.registerSingleton<RouteManager>(RouteManager());
  await NotificationManager.initializeNotifications(
      flutterLocalNotificationsPlugin);
  getIt.registerSingleton<FlutterLocalNotificationsPlugin>(
      flutterLocalNotificationsPlugin);
  getIt.registerSingleton<ConcernManager>(ConcernManager());

  // LegFactory
  // Register constructors for Legs
  LegFactory.register("WALK", (arg) => WalkLeg(json: arg));
  LegFactory.register("BUS", (arg) => BusLeg(json: arg));
  LegFactory.register("SUBWAY", (arg) => SubwayLeg(json: arg));
}
