import 'package:scheduler_app/entities/route.dart' as route_entity;
import 'package:scheduler_app/widgets/service_icon.dart';
import 'package:flutter/material.dart';

class RouteServicesWidget extends StatelessWidget {
  final route_entity.Route route;

  const RouteServicesWidget({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    List<Widget> serviceIcons = route.legs.map((leg) {
      return ServiceIconWidgetFactory.fromLeg(leg);
    }).toList();

    List<Widget> serviceIconsWithArrows = [];
    for (int i = 0; i < serviceIcons.length; i++) {
      serviceIconsWithArrows.add(serviceIcons[i]);
      if (i < serviceIcons.length - 1) {
        serviceIconsWithArrows.add(const Icon(Icons.chevron_right, size: 14));
      }
    }

    return Row(children: serviceIconsWithArrows);
  }
}
