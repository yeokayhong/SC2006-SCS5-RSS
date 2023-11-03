import 'package:flutter/material.dart';
import 'package:scheduler_app/entities/legtype_entity.dart';
import 'package:scheduler_app/widgets/legs_widget_methods.dart';
import 'package:scheduler_app/entities/stop_entity.dart' as s;
import 'package:scheduler_app/widgets/waiting_time.dart';

class TransitLegWidget extends StatelessWidget {
  late final waitingTime;
  late final List<s.Stop> stops;
  TransitLegWidget({super.key, required this.stops, required this.waitingTime});

  @override
  Widget build(BuildContext context) {
    return LegsWidget.buildStopList(stops);
  }
}
