import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';
import 'package:scheduler_app/managers/notification_manager.dart';
import 'package:scheduler_app/managers/route_manager.dart';

GetIt getIt = GetIt.instance;

void instanceSetUp() {
  getIt.registerSingleton<EventBus>(EventBus());
  getIt.registerSingleton<NotificationManager>(
      NotificationManager.getInstance());
  getIt.registerSingleton<RouteManager>(RouteManager());
}
