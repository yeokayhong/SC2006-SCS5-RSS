import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scheduler_app/entities/stop_entity.dart';
import 'package:scheduler_app/widgets/waiting_time.dart';
import 'package:scheduler_app/entities/duration.dart' as d;
import '../entities/leg_entity.dart';
import '../managers/route_manager.dart';
import 'package:scheduler_app/entities/step_entity.dart' as s;

abstract class LegsWidget {
  static Widget buildWalkingTile(String info) {
    return ListTile(
      leading: Icon(Icons.directions_walk),
      title: Text(info),
    );
  }

  static Widget buildBusTile(String title, String departure, String crowdInfo) {
    return ListTile(
      leading: CircleAvatar(child: Text('179')),
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(departure),
          Text(crowdInfo),
        ],
      ),
    );
  }

  static Widget buildStepList(List<s.Step> steps) {
    return ExpansionTile(
      title: Text('To Walk...'),
      children: steps
          .map(
            (step) => ListTile(
              title: Text(
                  "Walk ${step.distance.round()}m in the ${step.absoluteDirection} direction"),
            ),
          )
          .toList(),
    );
  }

  static Widget buildStopList(List<Stop> stops) {
    return ExpansionTile(
      title: Text('Ride ${stops.length} stop(s)'),
      children: stops
          .map(
            (stop) => Column(
              children: [
                ListTile(
                  title: Text("Bus Stop: ${stop.name}"),
                  subtitle: Text("Stop Code: ${stop.stopCode}"),
                ),
                WaitingTimeWidget(
                  duration: stop.waitingTime.toString(),
                )
              ],
            ),
          )
          .toList(),
    );
  }

  static Widget buildTrainInfoTile(
      String line, String destination, String frequency) {
    return ListTile(
      leading: Icon(Icons.train),
      title: Text('$line towards $destination'),
      subtitle: Text(frequency),
    );
  }

  static Widget buildTrainCrowdTile(String title, String crowdStatus) {
    return ListTile(
      title: Text(title),
      trailing: Text(crowdStatus),
    );
  }

  static Widget buildLocationTile(String title, String time,
      {String? liveStatus}) {
    return ListTile(
      title: Text(title),
      subtitle: Text(time),
      trailing: liveStatus != null ? Text('Live: $liveStatus') : null,
    );
  }
}
