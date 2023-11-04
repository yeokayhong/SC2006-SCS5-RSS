import 'package:scheduler_app/entities/route.dart' as route_entity;
import 'package:scheduler_app/widgets/leg.dart';
import 'package:flutter/material.dart';

class RouteDetailsWidget extends StatelessWidget {
  final route_entity.Route route;

  const RouteDetailsWidget({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: route.legs.length,
      itemBuilder: (context, index) {
        final leg = route.legs[index];

        return LegWidget.fromLeg(leg);
      },
    );
  }
}
