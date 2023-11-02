import 'package:scheduler_app/entities/route.dart' as route_entity;
import 'package:scheduler_app/entities/leg.dart';
import 'package:scheduler_app/widgets/legs.dart';
import 'package:flutter/material.dart';

class RouteDetailsPage extends StatefulWidget {
  final int routeNumber;
  final route_entity.Route routeData;
  const RouteDetailsPage(
      {super.key, required this.routeNumber, required this.routeData});

  @override
  State<RouteDetailsPage> createState() => _RouteDetailsPageState();
}

class _RouteDetailsPageState extends State<RouteDetailsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    List<Leg> legs = widget.routeData.legs;
    return Scaffold(
        appBar: AppBar(title: Text('Route #${widget.routeNumber} Details')),
        body: ListView.builder(
          itemCount: legs.length,
          itemBuilder: (context, index) {
            final leg = legs[index];
            return LegWidget.fromLeg(leg);
          },
        )
        // Column(
        //   children: [
        //     // 60% of the screen for Map
        //     Expanded(
        //       flex: 6,
        //       child: MapWidget(
        //         source: LatLng(1.320981,
        //             103.84415), // You can adjust these coordinates accordingly
        //         dest: LatLng(1.31875833025, 103.846554958),
        //         route: r.Route.placeholder(),
        //       ),
        //     ),
        //     // 40% of the screen for travel plan details
        //     Expanded(
        //       flex: 4,
        //       child: LegsWidget(),
        //     ),
        //   ],
        // ),
        );
  }
}
