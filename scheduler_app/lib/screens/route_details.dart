import 'package:scheduler_app/entities/route.dart' as route_entity;
import 'package:scheduler_app/managers/route_manager.dart';
import 'package:scheduler_app/entities/leg.dart';
import 'package:scheduler_app/widgets/legs.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RouteDetailsPage extends StatefulWidget {
  final int routeNumber;
  final RouteManager routeManager = GetIt.instance<RouteManager>();

  RouteDetailsPage({super.key, required this.routeNumber});

  @override
  State<RouteDetailsPage> createState() => _RouteDetailsPageState();
}

class _RouteDetailsPageState extends State<RouteDetailsPage> {
  late route_entity.Route routeData;
  late Stream<Map<int, route_entity.Route>> routeStream =
      widget.routeManager.routeStream;

  @override
  void initState() {
    routeData = widget.routeManager.getRoute(widget.routeNumber);
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    List<Leg> legs = routeData.legs;
    return Scaffold(
        appBar: AppBar(title: Text('Route #${widget.routeNumber} Details')),
        body: StreamBuilder(
            stream: routeStream,
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: legs.length,
                itemBuilder: (context, index) {
                  final leg = legs[index];
                  return LegWidget.fromLeg(leg);
                },
              );
            }),
        floatingActionButton: ElevatedButton(
          onPressed: () {
            widget.routeManager.setActiveRoute(routeData);
          },
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(
              fontSize: 16, // font size
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 30, vertical: 15), // padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // rounded corners
            ),
          ),
          child: const Text('Begin Journey'),
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
