import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:scheduler_app/entities/notification_entity.dart';
import 'package:scheduler_app/base_classes/set_up.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:csv/csv.dart';
import 'dart:io';

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
        print(field);
        return Notification(
          id: field[0],
          title: field[1],
          body: field[2],
          payload: jsonDecode(field[3]),
          time: DateTime.parse(field[4]),
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
        ['id', 'title', 'body', 'payload', 'time'],
      ];
      await file.writeAsString(
          const ListToCsvConverter().convert(defaultCsvData),
          mode: FileMode.write);
    } else {
      final List<List<dynamic>> csvData = _notifications
          .map((notification) => [
                notification.id,
                notification.title,
                notification.body,
                notification.payload.toString(),
                notification.time.toIso8601String(),
              ])
          .toList();
      // print(csvData);
      // print(const ListToCsvConverter().convert(csvData));
      try {
        await file.writeAsString(const ListToCsvConverter().convert(csvData),
            mode: FileMode.write);
        // print('CSV file updated successfully.');
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

  Future<void> _createNotificationObject(
      String title, String body, dynamic payload) async {
    await _addNotification(Notification(
      title: title,
      body: body,
      payload: payload,
    ));
  }

  static Future initializeNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    const AndroidInitializationSettings androidInitialize =
        AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettings =
        const InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: handleNotificationClick);
  }

  static Future<void> handleNotificationClick(
      NotificationResponse notificationResponse) async {
    jsonDecode(notificationResponse.payload ?? "");
  }

  Future<void> _displayRealTimeNotification(id, String title, String body,
      dynamic payload, FlutterLocalNotificationsPlugin fln) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'you can name it whatever1',
        'channelName',
        playSound: false,
        importance: Importance.max,
        priority: Priority.high,
      );
      const NotificationDetails notification =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await fln.show(0, title, body, notification,
          payload: jsonEncode(payload));
      // print('Successful');
    } catch (e) {
      // Handle any errors or exceptions here
      print("Notification display error: $e");
    }
  }

  Future<void> createNotification(
      {id = 0, title = "", body, payload = const {}, fln}) async {
    fln ??= getIt<FlutterLocalNotificationsPlugin>();
    await _createNotificationObject(title, body, payload);
    await _displayRealTimeNotification(id, title, body, payload, fln);
  }
}
