import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scheduler_app/widgets/waiting_time.dart';
import 'package:scheduler_app/entities/duration.dart' as d;
import '../entities/leg_entity.dart';
import '../managers/route_manager.dart';

class LegsWidget extends StatelessWidget {
  late Leg leg;
  LegsWidget({required this.leg});
  RouteManager routeManager = GetIt.instance<RouteManager>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildLocationTile('${leg.start.name}',
            '${routeManager.formatEndTime(leg.startTime.toString())}'),
        WaitingTimeWidget(duration: '2 min'),
        _buildWalkingTile('Walk 8 min (450 m)'),
        WaitingTimeWidget(duration: '3 min'),
        _buildLocationTile('Lee Wee Nam Lib', '3 PM: Usually not busy'),
        WaitingTimeWidget(duration: '5 min'),
        _buildBusTile(
            '179 Boon Lay International', 'Departed: 15:12', 'Not crowded'),
        _buildStopList(['Sch Of CEE', 'Sch of Comm & Info', 'Spms', '...']),
        WaitingTimeWidget(duration: '4 min'),
        _buildLocationTile('Pioneer Stn Exit B', '15:24',
            liveStatus: 'Not too busy'),
        _buildWalkingTile('Walk 1 min (70 m)'),
        WaitingTimeWidget(duration: '3 min'),
        _buildTrainInfoTile('East West Line', 'Pasir Ris', 'Every 6 min'),
        _buildTrainCrowdTile('What\'s it like on board?', 'Not too crowded'),
        _buildStopList(
            ['Boon Lay', 'Lakeside', 'Chinese Garden', 'Jurong East']),
        WaitingTimeWidget(duration: '7 min'),
        _buildLocationTile('Jurong East', '16:25', liveStatus: 'Not too busy'),
      ],
    );
  }

  Widget _buildWalkingTile(String info) {
    return ListTile(
      leading: Icon(Icons.directions_walk),
      title: Text(info),
    );
  }

  Widget _buildBusTile(String title, String departure, String crowdInfo) {
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

  Widget _buildStopList(List<String> stops) {
    return ExpansionTile(
      title: Text('Ride ${stops.length} stop(s) ( _ min(s))'),
      children: stops.map((stop) => ListTile(title: Text(stop))).toList(),
    );
  }

  Widget _buildTrainInfoTile(
      String line, String destination, String frequency) {
    return ListTile(
      leading: Icon(Icons.train),
      title: Text('$line towards $destination'),
      subtitle: Text(frequency),
    );
  }

  Widget _buildTrainCrowdTile(String title, String crowdStatus) {
    return ListTile(
      title: Text(title),
      trailing: Text(crowdStatus),
    );
  }

  Widget _buildLocationTile(String title, String time, {String? liveStatus}) {
    return ListTile(
      title: Text(title),
      subtitle: Text(time),
      trailing: liveStatus != null ? Text('Live: $liveStatus') : null,
    );
  }
}
