import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scheduler_app/base_classes/date_time_format.dart';
import 'package:scheduler_app/managers/notification_manager.dart';
import 'package:scheduler_app/entities/notification_entity.dart' as notification_entity;

void main() => runApp(MaterialApp(
  home: NotificationManager(),));

class NotificationManager extends StatelessWidget {
  //const PotentialConcernManager({super.key});
  List<notification_entity.Notification> notificationList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RECENT ALERTS'),
        centerTitle: true,
        backgroundColor: Colors.grey[200],            
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 40.0,
          fontWeight: FontWeight.bold),
      ),
      body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: notificationList.length,
                itemBuilder: (context, index) {
                  final object = notificationList[index];
                  return ListTile(
                    title: Text(object.message),
                    subtitle: Text(object.time.fullDate()),
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
