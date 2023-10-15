import 'package:flutter/material.dart';
import 'package:scheduler_app/entities/notification_entity.dart'
    as notification_entity;
import 'package:intl/intl.dart';
import 'package:scheduler_app/base_classes/set_up.dart';
import 'package:scheduler_app/managers/notification_manager.dart';
//import 'package:get_it/get_it.dart';
import 'package:scheduler_app/base_classes/date_time_format.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      body: ListView.builder(
              itemCount: notificationList.length,
              itemBuilder: (context, index) {
                final object = notificationList[index];
                return SizedBox(
                  height:150.0,
                  child: Stack(
                      children: [
                          Column(
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Expanded(
                                      flex: 1,
                                      child: SizedBox(
                                        width: 40.0,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: ListTile(
                                        title: Text(object.time.customFormat()),
                                        titleTextStyle: const TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        subtitle: Text(object.message),
                                        subtitleTextStyle: const TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 1.2,
                                color: Colors.black,
                              ),
                            ],
                      ),
                  const Positioned(
                    left: 20.0,
                    top :40.0,
                    child: Icon(
                        Icons.warning_amber_rounded,
                        size: 60.0,
                        color: Colors.red,
                    ),
                  ),
                  Positioned(
                    bottom: 8.0, // Adjust the bottom position as needed
                    right: 14.0, // Adjust the right position as needed
                    child: TextButton(
                      onPressed: () {
                      // Handle the "Read More" button click
                      },

                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade800),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.red),
                            )
                        )
                      ),

                      child: const Text(
                        'Read more',
                        style: TextStyle(
                        color: Colors.white,
                          //backgroundColor: Colors.red,
                        ),
                      ),

                    ),
                  )
                    ]
                  ),
                );
              },
            ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Text(''),
      // ),
    );
  }
}
