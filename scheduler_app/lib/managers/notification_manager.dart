import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:get_it/get_it.dart';
import 'package:event_bus/event_bus.dart';

import 'package:scheduler_app/entities/notification_entity.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:scheduler_app/managers/concern_manager.dart';

class NotificationManager {
  List<Notification> _notifications = [];
  static final NotificationManager _instance = NotificationManager._();
  EventBus get eventBus => GetIt.instance<EventBus>();

  NotificationManager._() {
    instantiateNotificationFile();
  }

  factory NotificationManager.getInstance() {
    return _instance;
  }

  void instantiateNotificationFile() async {
    final input = await rootBundle.loadString("assets/NotificationList.csv");
    final fields = const CsvToListConverter().convert(input);

    List<Notification> newNotifications = fields.map((field) {
      return Notification(
        time: DateTime.parse(field[0]),
        message: field[1],
      );
    }).toList();
    _notifications.addAll(newNotifications);
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
      try {
        await file.writeAsString(const ListToCsvConverter().convert(csvData),
            mode: FileMode.write,
            flush: true);
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

  Future<void> createNotifications(Concern event) async {
    await _addNotification(Notification(
      message: event.message,
      time: DateTime.now(),
    ));
  }

  static Future initializeNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    const AndroidInitializationSettings androidInitialize = AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future <void> displayRealTimeNotification(
      {required id,
      required String title,
      required String body,
      required FlutterLocalNotificationsPlugin fln}) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'you can name it whatever1',
        'channelName',
        playSound: true,
        importance: Importance.max,
        priority: Priority.high,
      );
      const NotificationDetails not = NotificationDetails(
          android: androidPlatformChannelSpecifics);
      await fln.show(0, title, body, not);
      print('Successful');
    } catch (e) {
      // Handle any errors or exceptions here
      print("Notification display error: $e");

      // You can also throw the error further if needed
      // throw e;
    }
  }
}
