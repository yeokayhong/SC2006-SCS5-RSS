import 'package:scheduler_app/entities/route.dart' as route_entity;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scheduler_app/screens/route_selection.dart';
import 'package:scheduler_app/widgets/address_input.dart';
import 'package:scheduler_app/entities/route_event.dart';
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
  bool isWrongInput = false;

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
      appBar: AppBar(title: const Text('Search Page')),
      body: Stack(
        children: [
          MapWidget(
            route: route_entity.Route.placeholder(),
          ),
          Positioned.fill(
            child: AddressSearchWidget(
                onOriginChanged: handleOriginChange,
                onDestinationChanged: handleDestinationChange),
          ),
          Positioned(
            bottom: 0,
            left: 5,
            right: 5,
            child: Column(
              children: [
                Visibility(
                  visible: isWrongInput,
                  child: SizedBox(
                    height: 30,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: const Text(
                      "Please choose a valid address",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 75,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: ElevatedButton(
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
                          setState(() {
                            isWrongInput = true;
                            Future.delayed(const Duration(seconds: 2), () {
                              setState(() {
                                isWrongInput = false;
                              });
                            });
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 16, // font size
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15), // padding
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // rounded corners
                        ),
                      ),
                      child: const Text('Search Routes'),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
