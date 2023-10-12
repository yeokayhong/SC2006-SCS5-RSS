import 'package:flutter/material.dart';
import 'package:scheduler_app/entities/notification_entity.dart'
    as notification_entity;
import 'package:intl/intl.dart';
import 'package:scheduler_app/base_classes/set_up.dart';
import 'package:scheduler_app/managers/notification_manager.dart';
import 'package:get_it/get_it.dart';

void main() {
  instanceSetUp();
  runApp(MaterialApp(
    home: NotificationUI(),
  ));
}

class NotificationUI extends StatelessWidget {
  //const PotentialConcernManager({super.key});
  final List<notification_entity.Notification> notificationList = getIt<NotificationManager>().getNotificationHistory();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RECENT ALERTS'),
        centerTitle: true,
        toolbarHeight: 120.0,
        elevation: 0.0,
        backgroundColor: Colors.grey[200],
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 40.0),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: notificationList.length,
              itemBuilder: (context, index) {
                final object = notificationList[index];
                return ListTile(
                  title: Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(object.time)),
                  subtitle: Text(object.message),
                );
              },
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Text(''),
      // ),
    );
  }
}
