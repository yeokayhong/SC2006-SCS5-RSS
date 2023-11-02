import 'package:scheduler_app/entities/stop.dart';
import 'package:flutter/material.dart';

abstract class StopWidget extends StatelessWidget {
  final Stop stop;

  const StopWidget({super.key, required this.stop});

  static StopWidget fromStop(stop) {
    switch (stop.runtimeType) {
      case BusStop:
        return BusStopWidget(stop: stop);
      case RailStop:
        return RailStopWidget(stop: stop);
      default:
        throw Exception("Invalid stop type");
    }
  }
}

class BusStopWidget extends StopWidget {
  const BusStopWidget({super.key, required Stop stop}) : super(stop: stop);

  @override
  Widget build(BuildContext context) {
    BusStop busStop = stop as BusStop;
    return ListTile(
      leading: const CircleAvatar(
        radius: 10,
        backgroundColor: Colors.red,
      ),
      title: Text(busStop.name),
    );
  }
}

class RailStopWidget extends StopWidget {
  const RailStopWidget({super.key, required Stop stop}) : super(stop: stop);

  @override
  Widget build(BuildContext context) {
    RailStop railStop = stop as RailStop;
    return ListTile(
      leading: const CircleAvatar(radius: 5),
      title: Text(railStop.name),
    );
  }
}
