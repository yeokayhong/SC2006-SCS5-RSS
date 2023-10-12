import 'package:get_it/get_it.dart';
import 'package:scheduler_app/managers/notification_manager.dart';

GetIt getIt = GetIt.instance;

void instanceSetUp(){
  getIt.registerSingleton<NotificationManager>(NotificationManager.getInstance());
}
