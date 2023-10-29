import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:get_it/get_it.dart';
import 'package:event_bus/event_bus.dart';
import 'package:scheduler_app/base_classes/set_up.dart';

import 'package:scheduler_app/entities/notification_entity.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:scheduler_app/managers/concern_manager.dart';

class NotificationManager {
  List<Notification> _notifications = [];
  static final NotificationManager _instance = NotificationManager._();
  EventBus get eventBus => GetIt.instance<EventBus>();

  NotificationManager._() {
    _instantiateNotificationFile();
  }

  factory NotificationManager.getInstance() {
    return _instance;
  }

  void _instantiateNotificationFile() async {
    final appDocumentsDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    final csvFilePath = '${appDocumentsDirectory.path}/NotificationList.csv';
    final File file = File(csvFilePath);
    try {
      final String fileContents = await file.readAsString();
      final fields = const CsvToListConverter().convert(fileContents);

      List<Notification> newNotifications = fields.map((field) {
        return Notification(
          time: DateTime.parse(field[0]),
          message: field[1],
        );
      }).toList();
      _notifications.addAll(newNotifications);
    } catch (e) {
      print('Error reading CSV file: $e');
    }
  }

  Future<void> updateNotificationFile() async {
    final appDocumentsDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    final csvFilePath = '${appDocumentsDirectory.path}/NotificationList.csv';
    final File file = File(csvFilePath);
    if (_notifications.isEmpty) {
      final defaultCsvData = [
        ['Timestamp', 'Message']
      ];
      await file.writeAsString(
          const ListToCsvConverter().convert(defaultCsvData),
          mode: FileMode.write);
    } else {
      final List<List<dynamic>> csvData = _notifications
          .map((notification) => [
                notification.time.toIso8601String(),
                '"${notification.message}"',
              ])
          .toList();
      print(csvData);
      print(const ListToCsvConverter().convert(csvData));
      try {
        await file.writeAsString(const ListToCsvConverter().convert(csvData),
            mode: FileMode.write);
        print('CSV file updated successfully.');
      } catch (e) {
        print('Error updating CSV file: $e');
      }
    }
  }

  Future<void> clearNotifications() async {
    _notifications.clear();
    await updateNotificationFile();
  }

  List<Notification> getNotificationHistory() {
    return _notifications;
  }

  Future<void> _addNotification(Notification toUpdate) async {
    _notifications.add(toUpdate);
    await updateNotificationFile();
  }

  Future<void> _createNotificationObject(String message) async {
    await _addNotification(Notification(
      message: message,
      time: DateTime.now(),
    ));
  }

  static Future initializeNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    const AndroidInitializationSettings androidInitialize =
        AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettings =
        const InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _displayRealTimeNotification(id, String title, String body,
      FlutterLocalNotificationsPlugin fln) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'you can name it whatever1',
        'channelName',
        playSound: true,
        importance: Importance.max,
        priority: Priority.high,
      );
      const NotificationDetails not =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await fln.show(0, title, body, not);
      print('Successful');
    } catch (e) {
      // Handle any errors or exceptions here
      print("Notification display error: $e");
    }
  }

  Future<void> createNotification({id = 0, title = "", body, fln}) async {
    if (fln == null) {
      fln = getIt<FlutterLocalNotificationsPlugin>();
    }
    await _createNotificationObject(body);
    await _displayRealTimeNotification(id, title, body, fln);
  }
}
