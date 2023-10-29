import 'package:flutter/widgets.dart';

class Notification {
  String id;
  final String title;
  final String body;
  final dynamic payload;
  DateTime time;

  Notification({
    String? id,
    required this.title,
    required this.body,
    this.payload,
    DateTime? time,
  })  : this.time = DateTime.now(),
        this.id = id ?? UniqueKey().toString();
}
