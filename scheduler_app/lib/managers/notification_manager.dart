import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:get_it/get_it.dart';
import 'package:event_bus/event_bus.dart';

import 'package:scheduler_app/entities/notification_entity.dart';
import 'package:scheduler_app/entities/event_entity.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationManager {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
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
          .map((notification) =>
      [
        notification.time.toIso8601String(),
        '"${notification.message}"',
      ])
          .toList();
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


  void createNotifications(ConcernEvent event){
      _addNotification(Notification(
        message: event.concern.message,
        time: DateTime.now(),
      ));
  }

  // Future<void> displayScheduledNotification(String title, String body, DateTime scheduledTime) async {
  //   final AndroidNotificationDetails androidPlatformChannelSpecifics =
  //   AndroidNotificationDetails(
  //     'your channel id',
  //     'your channel name',
  //     channelDescription: 'your channel description',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );
  //   final NotificationDetails platformChannelSpecifics =
  //   NotificationDetails(android: androidPlatformChannelSpecifics);

  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     0, // Notification ID (use a unique ID for each notification)
  //     title, // Notification title
  //     body, // Notification content
  //     TZDateTime.from(scheduledTime, tz.local), // Convert scheduledTime to a time-zone specific DateTime
  //     platformChannelSpecifics,
  //     androidAllowWhileIdle: true,
  //     uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime, // Use absoluteTime for precise scheduling
  //     payload: 'item x', // Optional payload
  //   );
  // }

  // eventBus.on<NotificationEvent>().listen((event) {
  // // Handle the event and display a real-time pop-up notification
  // displayRealTimeNotification("New Notification", event.message);
  // });

}