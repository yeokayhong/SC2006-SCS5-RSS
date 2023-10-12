//import 'package:flutter/services.dart';
//import 'package:scheduler_app/base_classes/notification_enum.dart';
import 'package:get_it/get_it.dart';
//import 'package:scheduler_app/entities/route_entity.dart';
import 'package:scheduler_app/entities/notification_entity.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'dart:convert' show utf8;

class NotificationManager {
  List<Notification> _notifications = [];
    //GetIt.instance.registerSingleton<NotificationManager>(NotificationManager());

  NotificationManager._(){
    instantiateNotificationFile();
  }
  
  void instantiateNotificationFile() async{
    final input = File('assets/NotificationList.csv').openRead();
    final fields = await input.transform(utf8.decoder).transform(CsvToListConverter()).toList();
    
    List<Notification> newNotifications = fields.map((field) {
      return Notification(
        message: field[0], 
        time: field[1], 
      );
    }).toList();
    _updateNotifications(newNotifications);
  }

  void updateNotificationFile(){
     final List<List<dynamic>> csvData = _notifications
        .map((notification) => [notification.time, notification.message])
        .toList();

    final String csvFilePath = 'NotificationList.csv';
    final File file = File(csvFilePath);

    try {
      file.writeAsString(const ListToCsvConverter().convert(csvData));
      print('CSV file updated successfully.');
    } catch (e) {
      print('Error updating CSV file: $e');
    }
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
      updateNotificationFile();
    }
  

  void _removeNotification(Notification toRemove) {
    _notifications.remove(toRemove);
  }

  void _addNotification(Notification toUpdate) {
    _notifications.add(toUpdate);
  }

  void sendUpdatedNotificationList(){

  }
}

