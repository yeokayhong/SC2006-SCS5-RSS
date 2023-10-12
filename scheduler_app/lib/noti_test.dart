import 'package:flutter/material.dart';
import 'package:scheduler_app/entities/notification_entity.dart'
    as notification_entity;
import 'package:intl/intl.dart';

void main() => runApp(MaterialApp(
      home: NotificationManager(),
    ));

class NotificationManager extends StatelessWidget {
  //const PotentialConcernManager({super.key});
  final List<notification_entity.Notification> notificationList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RECENT ALERTS'),
        centerTitle: true,
        backgroundColor: Colors.grey[200],
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 40.0, fontWeight: FontWeight.bold),
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
                  subtitle: Text(
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(object.time)),
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
