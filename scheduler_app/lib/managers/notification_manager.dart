import 'package:flutter/material.dart';
import 'package:scheduler_app/events.dart';
import 'package:scheduler_app/entities/route_entity.dart';

class NotificationManager {
  final List<Notification> _notifications = [];

  void sendUpdatedNotificationList(){

  }

  List<Notification> getNotificationHistory(){
      return _notifications;
  }

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

class Notification {
  String type;
  String message;  
  Route route;

  Notification(
    {required this.type, 
    required this.message});
}
