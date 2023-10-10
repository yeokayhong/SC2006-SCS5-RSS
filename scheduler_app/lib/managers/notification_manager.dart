import 'package:flutter/services.dart';
import 'package:scheduler_app/entities/event_entity.dart';
import 'package:get_it/get_it.dart';
import 'package:scheduler_app/entities/route_entity.dart';
import 'package:scheduler_app/entities/notification_entity.dart';
import 'package:csv/csv.dart';

class NotificationManager {
  final List<Notification> _notifications = [];

  void instantiateNotificationFile(){
    final _rawData = rootBundle.loadString("assets/NotificationList.csv");
    List<List<dynamic>> _data = const CsvToListConverter().convert(_rawData);
  }

  void updateNotificationFile(){

  }

  void sendUpdatedNotificationList(){

  }

  List<Notification> getNotificationHistory(){
      return _notifications;
  }

  // ignore: unused_element
  void _updateNotifications(List<Notification> newNotifications) {
    for (Notification newNotification in newNotifications) {
      _addNotification(newNotification);
    }

    for (Notification notification in _notifications) {
      if (newNotifications.contains(notification)) continue;
        _removeNotification(notification);
      }
    }
  

  void _removeNotification(Notification toRemove) {
    _notifications.remove(toRemove);
  }

  void _addNotification(Notification toUpdate) {
    _notifications.remove(toUpdate);
  }
}

