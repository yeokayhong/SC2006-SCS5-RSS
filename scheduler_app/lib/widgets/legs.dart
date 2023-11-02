import 'package:scheduler_app/entities/stop.dart';
import 'package:scheduler_app/widgets/stop.dart';
import 'package:scheduler_app/widgets/waiting_time.dart';
import 'package:flutter/material.dart';
import '../entities/leg.dart';

abstract class LegWidget extends StatelessWidget {
  final Leg leg;

  const LegWidget({super.key, required this.leg});

  static LegWidget fromLeg(Leg leg) {
    switch (leg.runtimeType) {
      case WalkLeg:
        return WalkLegWidget(leg: leg);
      case BusLeg:
        return BusLegWidget(leg: leg);
      case RailLeg:
        return RailLegWidget(leg: leg);
      default:
        throw Exception("Invalid leg type");
    }
  }
}

class BusLegWidget extends LegWidget {
  const BusLegWidget({super.key, required Leg leg}) : super(leg: leg);

  @override
  Widget build(BuildContext context) {
    BusLeg busLeg = leg as BusLeg;
    return Column(
      children: [
        Text("Waiting Time"),
        Text("Origin"),
        Column(
            children:
                busLeg.stops.map((stop) => StopWidget.fromStop(stop)).toList()),
        Text("End Stop")
      ],
    );
  }
}

class RailLegWidget extends LegWidget {
  const RailLegWidget({super.key, required Leg leg}) : super(leg: leg);

  @override
  Widget build(BuildContext context) {
    RailLeg railLeg = leg as RailLeg;
    return Column(
      children: [
        Text("Waiting Time"),
        Text("Origin"),
        // ListView.builder(
        //   itemCount: railLeg.stops.length,
        //   itemBuilder: (context, index) {
        //     final stop = railLeg.stops[index];
        //     return StopWidget.fromStop(stop);
        //   },
        // ),
        Text("End Stop")
      ],
    );
  }
}

class WalkLegWidget extends LegWidget {
  const WalkLegWidget({super.key, required Leg leg}) : super(leg: leg);

  @override
  Widget build(BuildContext context) {
    WalkLeg walkLeg = leg as WalkLeg;
    return Column(
      children: [Text("Origin"), Text("End Stop")],
    );
  }
}

// Widget _buildWalkingTile(String info) {
//   return ListTile(
//     leading: const Icon(Icons.directions_walk),
//     title: Text(info),
//   );
// }

// Widget _buildBusTile(String title, String departure, String crowdInfo) {
//   return ListTile(
//     leading: const CircleAvatar(child: Text('179')),
//     title: Text(title),
//     subtitle: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(departure),
//         Text(crowdInfo),
//       ],
//     ),
//   );
// }

// Widget _buildStopList(List<String> stops) {
//   return ExpansionTile(
//     title: Text('Ride ${stops.length} stop(s) ( _ min(s))'),
//     children: stops.map((stop) => ListTile(title: Text(stop))).toList(),
//   );
// }

// Widget _buildTrainInfoTile(
//     String line, String destination, String frequency) {
//   return ListTile(
//     leading: const Icon(Icons.train),
//     title: Text('$line towards $destination'),
//     subtitle: Text(frequency),
//   );
// }

// Widget _buildTrainCrowdTile(String title, String crowdStatus) {
//   return ListTile(
//     title: Text(title),
//     trailing: Text(crowdStatus),
//   );
// }

// Widget _buildLocationTile(String? title, String time, {String? liveStatus}) {
//   return ListTile(
//     title: Text(title ?? ""),
//     subtitle: Text(time),
//     trailing: liveStatus != null ? Text('Live: $liveStatus') : null,
//   );
// }