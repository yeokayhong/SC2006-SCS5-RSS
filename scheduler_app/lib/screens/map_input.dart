import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scheduler_app/entities/address.dart';
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
  late Address origin;
  late Address dest;
  void handleOriginChange(Address origin) {
    debugPrint("Origin selected: ${origin.latitude}, ${origin.longitude}");
    setState(() {
      this.origin = origin;
    });
  }

  void handleDestinationChange(Address destination) {
    debugPrint(
        "Destination selected: ${destination.latitude}, ${destination.longitude}");
    setState(() {
      dest = destination;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Page')),
      body: Stack(
        children: [
          Positioned.fill(
            child: AddressSearchWidget(
                onOriginChanged: handleOriginChange,
                onDestinationChanged: handleDestinationChange),
          ),
          Positioned(
            bottom: 0,
            left: 5,
            right: 5,
            child: SizedBox(
              height: 75,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: ElevatedButton(
                  onPressed: () {
                    if (origin != null || dest != null) {
                      eventBus.fire(RouteEvent(
                          "${origin.latitude},${origin.longitude}",
                          "${dest.latitude},${dest.longitude}",
                          "pt"));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RouteSelectionPage(),
                        ),
                      );
                    }
                  },
                  child: const Text('Search Routes'),
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(
                      fontSize: 16, // font size
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15), // padding
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // rounded corners
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
