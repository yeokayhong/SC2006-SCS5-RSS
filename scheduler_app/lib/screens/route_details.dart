import 'package:scheduler_app/entities/route_entity.dart' as route_entity;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scheduler_app/entities/leg_entity.dart';
import 'package:scheduler_app/widgets/legs.dart';
import 'package:scheduler_app/widgets/map.dart';
import '../managers/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'screens_barrel.dart';

class RouteDetailsPage extends StatefulWidget {
  final int route_number;
  final route_entity.Route route_data;
  const RouteDetailsPage(
      {super.key, required this.route_number, required this.route_data});

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
    List<Leg> legs = widget.route_data.legs;
    return Scaffold(
        appBar: AppBar(title: Text('Route #${widget.route_number} Details')),
        body: ListView.builder(
          itemCount: legs.length,
          itemBuilder: (context, index) {
            final leg = legs[index];

            return LegsWidget(
              leg: leg,
            );
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
