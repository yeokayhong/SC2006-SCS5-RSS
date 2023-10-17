import 'package:flutter/services.dart';
import 'package:scheduler_app/entities/notification_entity.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:get_it/get_it.dart';
import 'package:event_bus/event_bus.dart';
import 'package:scheduler_app/entities/event_entity.dart';

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
    //_updateNotifications(newNotifications);
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

  // ignore: unused_element
  Future<void> updateNotifications(List<Notification> newNotifications) async {
    for (Notification newNotification in newNotifications) {
      _addNotification(newNotification);
    }
    await updateNotificationFile();
  }

  void _addNotification(Notification toUpdate) {
    _notifications.add(toUpdate);
  }

  void checkForUpdates(){
    List<Notification> tempNotification = [];
    List<ConcernEvent> accumulatedEvents = [];
    eventBus.on<ConcernEvent>().listen((event) {
      if (event.type == "added") {
        accumulatedEvents.add(event);
      }
    });
    for (ConcernEvent event in accumulatedEvents){
      tempNotification.add(receiveNotifications(event));
    }
    updateNotifications(tempNotification);
  }

  Notification receiveNotifications(ConcernEvent event){
      return Notification(
        message: event.concern.message,
        time: DateTime.now(),
      );
  }
}