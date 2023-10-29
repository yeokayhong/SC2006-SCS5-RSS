import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scheduler_app/entities/route_event.dart';
import 'package:scheduler_app/screens/route_selection.dart';
import 'package:scheduler_app/widgets/address_input.dart';
import 'screens_barrel.dart';
import 'package:scheduler_app/widgets/map.dart';
import 'package:scheduler_app/entities/route_entity.dart' as r;

class MapInputPage extends StatefulWidget {
  const MapInputPage({super.key});

  @override
  State<MapInputPage> createState() => _MapInputPageState();
}

class _MapInputPageState extends State<MapInputPage> {
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
          // MapWidget(
          //   source: LatLng(1.320981, 103.84415),
          //   dest: LatLng(1.31875833025, 103.846554958),
          //   route: r.Route.placeholder(),
          // ),

          AddressSearchWidget(
              onOriginChanged: handleOriginChange,
              onDestinationChanged: handleDestinationChange),

          ElevatedButton(
            onPressed: () {
              eventBus.fire(RouteEvent(
                  "1.393454,103.739601", "1.379828,103.760057", "pt"));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RouteSelectionPage(),
                ),
              );
            },
            child: const Text('Search Routes'),
          )
        ],
      ),
    );
  }
}
