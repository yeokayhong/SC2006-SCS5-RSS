import 'package:scheduler_app/entities/route.dart' as route_entity;
import 'package:scheduler_app/widgets/map.dart';
import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  final route_entity.Route? route;

  const MapPage({super.key, this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Map Page"),
        ),
        body: MapWidget(route: route));
  }
}
