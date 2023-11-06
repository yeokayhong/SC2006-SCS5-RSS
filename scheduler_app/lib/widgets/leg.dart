import 'package:scheduler_app/widgets/stop.dart';
import 'package:flutter/material.dart';
import '../entities/leg.dart';

class LegWidgetFactory {
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

abstract class LegWidget extends StatelessWidget {
  final Leg leg;

  const LegWidget({super.key, required this.leg});
}

class BusLegWidget extends LegWidget {
  const BusLegWidget({super.key, required Leg leg}) : super(leg: leg);

  @override
  Widget build(BuildContext context) {
    BusLeg busLeg = leg as BusLeg;
    return Column(
      children: [
        const Divider(),
        ListTile(
          title: Text(busLeg.serviceName ?? ""),
        ),
        BusOriginWidget(stop: busLeg.origin),
        Text("Waiting Time"),
        Column(
            children: busLeg.intermediateStops
                .map((stop) => BusStopWidget(stop: stop))
                .toList()),
        BusDestinationWidget(stop: busLeg.destination),
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
        const Divider(),
        Text("Waiting Time"),
        RailOriginWidget(stop: railLeg.origin),
        Column(
            children: railLeg.intermediateStops
                .map((stop) => RailStopWidget(stop: stop))
                .toList()),
        RailDestinationWidget(stop: railLeg.destination),
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
      children: [
        const Divider(),
        WalkOriginWidget(stop: walkLeg.origin),
        WalkDestinationWidget(stop: walkLeg.destination)
      ],
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