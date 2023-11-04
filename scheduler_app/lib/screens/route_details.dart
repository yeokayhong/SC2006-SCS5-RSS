import 'package:scheduler_app/entities/route.dart' as route_entity;
import 'package:scheduler_app/managers/route_manager.dart';
import 'package:scheduler_app/entities/leg.dart';
import 'package:scheduler_app/widgets/legs.dart';
import 'package:scheduler_app/widgets/map.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RouteDetailsPage extends StatefulWidget {
  final route_entity.Route route;
  final RouteManager routeManager = GetIt.instance<RouteManager>();

  RouteDetailsPage({super.key, required this.route});

  @override
  State<RouteDetailsPage> createState() => _RouteDetailsPageState();
}

class _RouteDetailsPageState extends State<RouteDetailsPage> {
  late route_entity.Route routeData;
  late Stream<route_entity.Route> routeStream = widget.routeManager.routeStream
      .map((routesMap) => routesMap[widget.route.mapIndex])
      .where((route) => route != null)
      .cast<route_entity.Route>();

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Route #${widget.route.mapIndex} Details'),
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
            icon: const Icon(Icons.map),
          )
        ],
      ),
      body: StreamBuilder<route_entity.Route>(
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
                            child: LegWidget.fromLeg(leg),
                          ),
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
