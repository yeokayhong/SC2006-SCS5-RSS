import 'package:scheduler_app/entities/notification_entity.dart'
    as notification_entity;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationDetailsWidget extends StatefulWidget {
  final Function(String) onRequest;
  final notification_entity.Notification notification;

  const NotificationDetailsWidget({
    Key key = const Key('address_search'),
    required this.onRequest,
    required this.notification,
  }) : super(key: key);

  @override
  _NotificationDetailsWidgetState createState() =>
      _NotificationDetailsWidgetState();
}

class _NotificationDetailsWidgetState extends State<NotificationDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                widget.notification.title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text(
                      DateFormat("dd MMM yyyy hh:mma")
                          .format(widget.notification.time),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal)),
                ],
              )
            ])),
        Text(widget.notification.body),
      ],
    );
  }
}
