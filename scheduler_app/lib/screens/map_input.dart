import 'package:scheduler_app/entities/route.dart' as route_entity;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scheduler_app/entities/route_event.dart';
import 'package:scheduler_app/screens/route_selection.dart';
import 'package:scheduler_app/widgets/address_input.dart';
import 'package:scheduler_app/entities/address.dart';
import 'package:scheduler_app/widgets/map.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class MapInputPage extends StatefulWidget {
  const MapInputPage({super.key});

  @override
  State<MapInputPage> createState() => _MapInputPageState();
}

class _MapInputPageState extends State<MapInputPage> {
  // implement the function callbacks for address search
  EventBus get eventBus => GetIt.instance<EventBus>();
  Address? origin;
  Address? destination;

  void handleOriginChange(Address newOrigin) {
    debugPrint(
        "Origin selected: ${newOrigin.latitude}, ${newOrigin.longitude}");
    setState(() {
      origin = newOrigin;
    });
  }

  void handleDestinationChange(Address newDestination) {
    debugPrint(
        "Destination selected: ${newDestination.latitude}, ${newDestination.longitude}");
    setState(() {
      destination = newDestination;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Map Page')),
        body: Stack(
          children: [
            MapWidget(
              source: const LatLng(1.320981, 103.84415),
              dest: const LatLng(1.31875833025, 103.846554958),
              route: route_entity.Route.placeholder(),
            ),
            AddressSearchWidget(
                onOriginChanged: handleOriginChange,
                onDestinationChanged: handleDestinationChange),
          ],
        ),
        floatingActionButton: ElevatedButton(
          onPressed: () {
            if (origin != null && destination != null) {
              eventBus.fire(RouteEvent(
                  "${origin!.latitude},${origin!.longitude}",
                  "${destination!.latitude},${destination!.longitude}",
                  "pt"));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RouteSelectionPage(),
                ),
              );
            } else {
              // pending merge
            }
          },
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(
              fontSize: 16, // font size
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 30, vertical: 15), // padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // rounded corners
            ),
          ),
          child: const Text('Search Routes'),
        ));
  }
}
