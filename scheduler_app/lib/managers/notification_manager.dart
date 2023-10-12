//import 'package:scheduler_app/base_classes/notification_enum.dart';
//import 'package:scheduler_app/entities/route_entity.dart';
//import 'package:get_it/get_it.dart';
import 'package:flutter/services.dart';
import 'package:scheduler_app/entities/notification_entity.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'dart:convert' show utf8;

class NotificationManager {
  List<Notification> _notifications = [];

  NotificationManager._() {
    instantiateNotificationFile();
  }
  static final NotificationManager _instance = NotificationManager._();

  factory NotificationManager.getInstance() {
    return _instance;
  }

  void instantiateNotificationFile() async {
    final input = await rootBundle.loadString("assets/NotificationList.csv");
    final fields =  const CsvToListConverter().convert(input);

    List<Notification> newNotifications = fields.map((field) {
      return Notification(
        time: field[0],
        message: field[1],
      );
    }).toList();
    _updateNotifications(newNotifications);
  }

  void updateNotificationFile() {
    final List<List<dynamic>> csvData = _notifications
        .map((notification) => [notification.time.toIso8601String(), notification.message])
        .toList();

    final String csvFilePath = 'assets/NotificationList.csv';
    final File file = File(csvFilePath);

    try {
      file.writeAsString(const ListToCsvConverter().convert(csvData));
      print('CSV file updated successfully.');
    } catch (e) {
      print('Error updating CSV file: $e');
    }
  }

  List<Notification> getNotificationHistory() {
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

  void sendUpdatedNotificationList() {}
}
