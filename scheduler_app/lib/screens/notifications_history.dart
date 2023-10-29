import 'package:scheduler_app/entities/notification_entity.dart'
    as notification_entity;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:scheduler_app/base_classes/date_time_format.dart';
import 'package:scheduler_app/managers/notification_manager.dart';
import 'package:scheduler_app/widgets/notification_details.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class NotificationUI extends StatefulWidget {
  @override
  State<NotificationUI> createState() => _NotificationUIState();
}

class _NotificationUIState extends State<NotificationUI> {
  List<notification_entity.Notification> notificationList = [];
  EventBus get eventBus => GetIt.instance<EventBus>();
  GetIt getIt = GetIt.instance;

  @override
  void initState() {
    super.initState();
    //_setupEventListeners();
    notificationList =
        getIt<NotificationManager>().getNotificationHistory().reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RECENT ALERTS'),
        centerTitle: true,
        toolbarHeight: 120.0,
        elevation: 0.0,
        backgroundColor: Colors.grey[200],
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 40.0),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNotifications,
        child: ListView.builder(
          itemCount: notificationList.length,
          itemBuilder: (context, index) {
            final notification = notificationList[index];
            const maxSubtitleLength = 100;

            final isSubtitleLong = notification.body.length > maxSubtitleLength;

            // Extract the displayed subtitle text
            final displayedSubtitle = isSubtitleLong
                ? '${notification.body.substring(0, maxSubtitleLength)}...'
                : notification.body; // Display full subtitle

            return SizedBox(
              height: 150.0,
              child: Stack(children: [
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
                              title: Text(notification.time.customFormat()),
                              titleTextStyle: const TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              subtitle: Text(displayedSubtitle),
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
                  top: 40.0,
                  child: Icon(
                    Icons.warning_amber_rounded,
                    size: 60.0,
                    color: Colors.red,
                  ),
                ),
                Positioned(
                  bottom: 8.0,
                  right: 14.0,
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Notification Details'),
                            content: NotificationDetailsWidget(
                              notification: notification,
                              onRequest: (String message) {
                                return;
                              },
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.red.shade800),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(color: Colors.red),
                        ))),
                    child: const Text(
                      'Read more',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ]),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NotificationManager manager = getIt<NotificationManager>();
          manager.createNotification(title: "Title", body: "Message");
        },
        backgroundColor: Colors.red.shade800,
        child: const Icon(Icons.delete),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text(
              'Are you sure you want to delete the notification list?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                getIt<NotificationManager>()
                    .clearNotifications(); // Clear notifications
                updateNotificationList();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  // void _setupEventListeners() {
  //   eventBus.on<ConcernEvent>().listen((event) async {
  //     await getIt<NotificationManager>().displayRealTimeNotification(
  //       id: 0,
  //       title: 'title',
  //       body: event.concern.message,
  //       fln: getIt<FlutterLocalNotificationsPlugin>());
  //     await getIt<NotificationManager>().createNotifications(event);
  //     updateNotificationList();
  //   });
  // }

  void updateNotificationList() {
    setState(() {
      notificationList = getIt<NotificationManager>()
          .getNotificationHistory()
          .reversed
          .toList();
    });
  }

  Future<void> _refreshNotifications() async {
    // You can call an API or update your data source here
    await Future.delayed(const Duration(seconds: 1));
    updateNotificationList();
  }
}
