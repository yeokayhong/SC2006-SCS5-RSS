import 'package:scheduler_app/entities/route.dart' as route_entity;
import 'package:scheduler_app/managers/route_manager.dart';
import 'package:scheduler_app/widgets/service_icon.dart';
import 'package:scheduler_app/widgets/leg.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RouteDetailsWidget extends StatelessWidget {
  final routeManager = GetIt.instance<RouteManager>();
  final route_entity.Route route;

  RouteDetailsWidget({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<route_entity.Route>(
        initialData: route,
        stream: routeManager.routeStream
            .map((routesMap) => routesMap[route.mapIndex])
            .where((route) => route != null)
            .cast<route_entity.Route>(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Error: ${snapshot.error}");
          }
          route_entity.Route activeRoute = snapshot.data!;
          return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(activeRoute.origin.street_address(),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.95))),
                    ServiceIconWidget.fromLeg(activeRoute.currentLeg!),
                    Text(activeRoute.currentStop?.name ?? ""),
                    Text(activeRoute.currentLeg?.destination.name ?? ""),
                    Text(activeRoute.destination.street_address(),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.95)))
                  ]));
        });
  }
}
