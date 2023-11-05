import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scheduler_app/entities/leg_entity.dart';
import '../managers/route_manager.dart';
import 'screens_barrel.dart';
import 'package:scheduler_app/widgets/legs_widget_methods.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scheduler_app/widgets/map.dart';
import 'package:scheduler_app/entities/route_entity.dart' as r;

class RouteDetailsPage extends StatefulWidget {
  final r.Route route;
  const RouteDetailsPage({super.key, required this.route});

  @override
  State<RouteDetailsPage> createState() => _RouteDetailsPageState();
}

class _RouteDetailsPageState extends State<RouteDetailsPage> {
  GetIt getIt = GetIt.instance;
  late Stream<r.Route> routeStream;
  @override
  void initState() {
    super.initState();
    // gets the route stream for the target route object.
    routeStream = getIt<RouteManager>()
        .routeStream
        .map((routesMap) => routesMap[widget.route.mapIndex])
        .where((route) => route != null)
        .cast<r.Route>();
    debugPrint("Print routeStream: $routeStream");
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Route #${widget.route.mapIndex} Details'),
        // can remove this i was using this to test if the map widget is working
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapWidget(route: widget.route),
                ),
              );
            },
            icon: Icon(Icons.map),
          )
        ],
      ),
      body: StreamBuilder<r.Route>(
        initialData: widget.route,
        stream: routeStream,
        builder: (context, snapshot) {
          debugPrint(
              "Snapshot State for Route Details: ${snapshot.connectionState}");
          if (!snapshot.hasData || snapshot.hasError) {
            return const Center(
              child: Text('Route not available, please search route again.'),
            );
          } else {
            final route = snapshot.data!;
            List<Leg> legs = route.legs;

            return Column(
              children: [
                Expanded(
                  child: MapWidget(route: route),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: legs.length,
                    itemBuilder: (context, index) {
                      // if (index == 0) {
                      //   return Column();
                      // } else if (index == legs.length - 1) {
                      //   return Column();
                      // }
                      final leg = legs[index];

                      return Column(
                        // Leg Start
                        children: [
                          SizedBox(
                            height: 60,
                            child: LegsWidget.buildLocationTile(
                              leg.start.name,
                              RouteManager.formatEndTime(
                                endTimeInUnix: leg.startTime.toString(),
                              ),
                              liveStatus: leg.legType.waitingTime,
                            ),
                          ),
                          leg.legType.createLeg(),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
