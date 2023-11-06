import 'package:scheduler_app/entities/route.dart' as route_entity;
import 'package:scheduler_app/managers/route_manager.dart';
import 'package:scheduler_app/widgets/service_icon.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RouteDetailsWidget extends StatelessWidget {
  final routeManager = GetIt.instance<RouteManager>();
  final route_entity.Route route;

  RouteDetailsWidget({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(route.origin.street_address(),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.95))),
          ServiceIconWidgetFactory.fromLeg(route.currentLeg!),
          Text(route.currentStop?.name ?? ""),
          Text(route.currentLeg?.destination.name ?? ""),
          Text(route.destination.street_address(),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.95))),
          const Divider(),
          ...route.concerns.map((concern) {
            return Text(concern.message);
          }).toList()
        ]));
  }
}
