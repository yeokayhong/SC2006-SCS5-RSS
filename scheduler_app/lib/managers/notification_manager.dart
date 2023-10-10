import 'package:flutter/services.dart';
import 'package:scheduler_app/base_classes/notification_enum.dart';
import 'package:scheduler_app/entities/event_entity.dart';
import 'package:get_it/get_it.dart';
import 'package:scheduler_app/entities/route_entity.dart';
import 'package:scheduler_app/entities/notification_entity.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'dart:convert' show utf8;

class NotificationManager {
  final List<Notification> _notifications = [];

  void instantiateNotificationFile() async{
    final input = File('assets/NotificationList.csv').openRead();
    final fields = await input.transform(utf8.decoder).transform(CsvToListConverter()).toList();
    
    List<Notification> _newNotifications = fields.map((field) {
      return Notification({
        field[0], 
        field[1], 
        field[2],
        field[3],
        field[4],
      });
    }).toList();
    _updateNotifications(_newNotifications);
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

