import 'package:flutter/material.dart';
import 'package:scheduler_app/events.dart';

class NotificationManager {
  final List<Notification> _notifications = [];

  void sendUpdatedNotificationList(){

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
    if (_notifications.remove(toRemove)) {
    }
  }

  void _addNotification(Notification toUpdate) {
    if (_notifications.remove(toUpdate)) {
    }
    else {
  
    }
  }
}

class Notification {

}
