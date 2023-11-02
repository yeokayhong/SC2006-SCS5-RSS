import 'package:scheduler_app/entities/stop.dart';
import 'package:flutter/material.dart';

abstract class StopWidget extends StatelessWidget {
  final Stop stop;
  final bool isCurrentPosition = false;

  const StopWidget({super.key, required this.stop});
}

class BusOriginWidget extends StopWidget {
  const BusOriginWidget({super.key, required Stop stop}) : super(stop: stop);

  @override
  Widget build(BuildContext context) {
    BusStop busStop = stop as BusStop;
    return ListTile(
      leading: const SizedBox(
          width: 32,
          child: Align(
              alignment: Alignment.center,
              child:
                  CircleAvatar(child: Icon(Icons.directions_bus, size: 20)))),
      title: Text(busStop.name),
    );
  }
}

class BusStopWidget extends StopWidget {
  const BusStopWidget({super.key, required Stop stop}) : super(stop: stop);

  @override
  Widget build(BuildContext context) {
    BusStop busStop = stop as BusStop;
    return ListTile(
      leading: const SizedBox(
          width: 32,
          child: Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.red,
              ))),
      title: Text(busStop.name),
    );
  }
}

class BusDestinationWidget extends StopWidget {
  const BusDestinationWidget({super.key, required Stop stop})
      : super(stop: stop);

  @override
  Widget build(BuildContext context) {
    BusStop busStop = stop as BusStop;
    return ListTile(
      leading: const SizedBox(
          width: 32,
          child: Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.blue,
              ))),
      title: Text(busStop.name),
    );
  }
}

class RailOriginWidget extends StopWidget {
  const RailOriginWidget({super.key, required Stop stop}) : super(stop: stop);

  @override
  Widget build(BuildContext context) {
    RailStop railStop = stop as RailStop;
    return ListTile(
      leading: const SizedBox(
          width: 32,
          child: Align(
              alignment: Alignment.center,
              child: CircleAvatar(child: Icon(Icons.train, size: 20)))),
      title: Text(railStop.name),
    );
  }
}

class RailStopWidget extends StopWidget {
  const RailStopWidget({super.key, required Stop stop}) : super(stop: stop);

  @override
  Widget build(BuildContext context) {
    RailStop railStop = stop as RailStop;
    return ListTile(
      leading: const SizedBox(
          width: 32,
          child: Align(
              alignment: Alignment.center, child: CircleAvatar(radius: 5))),
      title: Text(railStop.name),
    );
  }
}

class RailDestinationWidget extends StopWidget {
  const RailDestinationWidget({super.key, required Stop stop})
      : super(stop: stop);

  @override
  Widget build(BuildContext context) {
    RailStop railStop = stop as RailStop;
    return ListTile(
      leading: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CircleAvatar(radius: 5)]),
      title: Text(railStop.name),
    );
  }
}

class WalkOriginWidget extends StopWidget {
  const WalkOriginWidget({super.key, required Stop stop}) : super(stop: stop);

  @override
  Widget build(BuildContext context) {
    WalkStop walkStop = stop as WalkStop;
    return ListTile(
      leading: const SizedBox(
          width: 32,
          child: Align(
              alignment: Alignment.center,
              child:
                  CircleAvatar(child: Icon(Icons.directions_walk, size: 20)))),
      title: Text(walkStop.name),
    );
  }
}

class WalkDestinationWidget extends StopWidget {
  const WalkDestinationWidget({super.key, required Stop stop})
      : super(stop: stop);

  @override
  Widget build(BuildContext context) {
    WalkStop walkStop = stop as WalkStop;
    return ListTile(
      leading: const SizedBox(
          width: 32,
          child: Align(
              alignment: Alignment.center, child: CircleAvatar(radius: 5))),
      title: Text(walkStop.name),
    );
  }
}
