import 'package:scheduler_app/entities/route.dart' as route_entity;
import 'package:scheduler_app/managers/route_manager.dart';
import 'package:scheduler_app/widgets/service_icon.dart';
import 'package:scheduler_app/entities/duration.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RouteSelectionWidget extends StatelessWidget {
  final routeManager = GetIt.instance<RouteManager>();
  final Function(route_entity.Route) onRouteSelect;
  final Map<int, route_entity.Route> routes;

  RouteSelectionWidget(
      {super.key, required this.routes, required this.onRouteSelect});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: routes.length,
      itemBuilder: (context, index) {
        final routeKey = routes.keys.elementAt(index);
        route_entity.Route routeValue = routes[routeKey]!;

        return ListTile(
          contentPadding: const EdgeInsets.all(16.0),
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Text(routeKey.toString(), // Route index as string
                style: const TextStyle(color: Colors.white)),
          ),
          title: Row(
              children: routes[routeKey]!.legs.map((leg) {
            return ServiceIconWidget.fromLeg(leg);
          }).toList()),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fare(SGD): ${routeValue.fare}', // Assuming fare is a field on r.Route
                style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
              ),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios,
              size: 20.0, color: Colors.blueAccent),
          onTap: () {
            onRouteSelect(routeValue);
          },
        );
      },
    );
  }
}
