import 'package:scheduler_app/entities/route.dart' as route_entity;
import 'package:scheduler_app/managers/route_manager.dart';
import 'package:scheduler_app/widgets/route_services.dart';
import 'package:scheduler_app/entities/duration.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RouteSelectionWidget extends StatefulWidget {
  final routeManager = GetIt.instance<RouteManager>();
  final Function(route_entity.Route) onRouteChange;
  final Function(route_entity.Route) onRouteSelect;
  final Map<int, route_entity.Route> routes;
  final route_entity.Route? initialRoute;

  RouteSelectionWidget(
      {super.key,
      required this.routes,
      required this.onRouteChange,
      required this.onRouteSelect,
      this.initialRoute});

  @override
  State<RouteSelectionWidget> createState() => _RouteSelectionWidgetState();
}

class _RouteSelectionWidgetState extends State<RouteSelectionWidget> {
  late Map<int, int> routeSelections;
  int selection = 0;

  @override
  void initState() {
    super.initState();

    Map<int, int> newRouteSelections = {};
    int index = 0;
    for (int routeKey in widget.routes.keys) {
      newRouteSelections[index] = routeKey;
      index++;
    }

    setState(() {
      routeSelections = newRouteSelections;
    });

    if (widget.initialRoute != null) {
      widget.onRouteChange(widget.initialRoute!);
      setState(() {
        selection = newRouteSelections.values
            .toList()
            .indexOf(widget.initialRoute!.mapIndex);
      });
    } else {
      widget.onRouteChange(widget.routes[newRouteSelections[selection]]!);
    }
  }

  void nextRoute() {
    int newSelection = ((selection + 1) % routeSelections.length);
    widget.onRouteChange(widget.routes[routeSelections[newSelection]]!);

    setState(() {
      selection = newSelection;
    });
  }

  void previousRoute() {
    int newSelection = ((selection - 1) % routeSelections.length);
    widget.onRouteChange(widget.routes[routeSelections[newSelection]]!);

    setState(() {
      selection = newSelection;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: InkWell(
                      onTap: () {
                        route_entity.Route route =
                            widget.routes[routeSelections[selection]]!;
                        widget.onRouteSelect(route);
                      },
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RouteServicesWidget(
                                route:
                                    widget.routes[routeSelections[selection]]!),
                            const Divider(),
                            Text(
                              Duration.formatDuration(widget
                                  .routes[routeSelections[selection]]!
                                  .duration
                                  .totalDuration),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Text(
                              '${widget.routes[routeSelections[selection]]!.fare}SGD',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold),
                            ),
                          ]))),
              Column(children: [
                Expanded(
                    child: TextButton(
                        onPressed: previousRoute,
                        child: const Icon(Icons.keyboard_arrow_up))),
                Expanded(
                    child: TextButton(
                        onPressed: nextRoute,
                        child: const Icon(Icons.keyboard_arrow_down))),
              ])
            ]));
  }
}
