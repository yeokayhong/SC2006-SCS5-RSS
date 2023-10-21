import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scheduler_app/APIs/routes_api.dart';
import 'package:scheduler_app/widgets/address_input.dart';
import '../managers/route_manager.dart';
import 'screens_barrel.dart';
import 'package:scheduler_app/widgets/map.dart';
import 'package:scheduler_app/entities/route_entity.dart' as r;
import 'package:intl/intl.dart';

class MapInputPage extends StatelessWidget {
  // implement the function callbacks for address search
  EventBus get eventBus => GetIt.instance<EventBus>();
  void handleOriginChange(String origin) {
    debugPrint("Origin selected: $origin");
  }

  void handleDestinationChange(String destination) {
    debugPrint("Destination selected: $destination");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map Page')),
      body: Column(
        children: [
          // temporarily substitute values in for testing
          Flexible(
            flex: 2,
            child: MapWidget(
              source: LatLng(1.320981, 103.84415),
              dest: LatLng(1.31875833025, 103.846554958),
              route: r.Route(),
            ),
          ),
          Flexible(
            flex: 1,
            child: AddressSearchWidget(
                onOriginChanged: handleOriginChange,
                onDestinationChanged: handleDestinationChange),
          ),
          ElevatedButton(
            onPressed: () {
              // _showRouteOptions(context);
              // for actual implementation of fetching data, this will be done on Route Manager, this event should notify the Route Manager.
              eventBus.fire(RouteEvent(
                  "1.320981,103.84415", "1.318758,103.846554", "pt"));
            },
            child: const Text('Search Routes'),
          )
        ],
      ),
    );
  }

  void _showRouteOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Route options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Route 1'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RouteDetailsPage(routeNumber: 1),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Route 2'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RouteDetailsPage(routeNumber: 2),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Route 3'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RouteDetailsPage(routeNumber: 3),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
