import 'package:flutter/material.dart';
import 'package:scheduler_app/widgets/map.dart';
import 'package:scheduler_app/entities/route.dart' as route_entity;

class MapPage extends StatefulWidget {
  late route_entity.Route route;
  MapPage({super.key, required this.route});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map Page"),
      ),
      body: MapWidget(route: widget.route),
    );
  }
}
