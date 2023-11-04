import 'package:scheduler_app/entities/route_selection_notifier.dart';
import 'package:scheduler_app/entities/route.dart' as route_entity;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scheduler_app/widgets/route_selection.dart';
import 'package:scheduler_app/managers/route_manager.dart';
import 'package:scheduler_app/widgets/search_button.dart';
import 'package:scheduler_app/widgets/route_details.dart';
import 'package:scheduler_app/widgets/address_input.dart';
import 'package:scheduler_app/entities/route_event.dart';
import 'package:scheduler_app/entities/address.dart';
import 'package:scheduler_app/widgets/map.dart';
import 'package:event_bus/event_bus.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class MapInputPage extends StatefulWidget {
  final routeManager = GetIt.instance<RouteManager>();
  final _addressSearchFocus = FocusNode();

  MapInputPage({super.key});

  @override
  State<MapInputPage> createState() => _MapInputPageState();
}

class _MapInputPageState extends State<MapInputPage> {
  // implement the function callbacks for address search
  EventBus get eventBus => GetIt.instance<EventBus>();
  bool isWrongInput = false;
  String searchState = "waiting";

  void handleOriginChange(Address newOrigin) {
    debugPrint(
        "Origin selected: ${newOrigin.latitude}, ${newOrigin.longitude}");
    final routeSelectionNotifier =
        Provider.of<RouteSelectionNotifier>(context, listen: false);
    routeSelectionNotifier.origin = newOrigin;
  }

  void handleDestinationChange(Address newDestination) {
    debugPrint(
        "Destination selected: ${newDestination.latitude}, ${newDestination.longitude}");
    final routeSelectionNotifier =
        Provider.of<RouteSelectionNotifier>(context, listen: false);
    routeSelectionNotifier.destination = newDestination;
  }

  @override
  void reassemble() {
    super.reassemble();
    widget.routeManager.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Consumer<RouteSelectionNotifier>(builder: (context, value, child) {
              return MapWidget(
                  route: value.route,
                  origin: Address.toLatLng(value.origin),
                  destination: Address.toLatLng(value.destination));
            }),
            Focus(
              focusNode: widget._addressSearchFocus,
              child: AddressSearchWidget(
                  onOriginChanged: handleOriginChange,
                  onDestinationChanged: handleDestinationChange),
            ),
            Positioned(
                left: 5,
                right: 5,
                bottom: 5,
                child: Visibility(
                    visible: searchState == "waiting" &&
                        !widget._addressSearchFocus.hasFocus,
                    child: Consumer<RouteSelectionNotifier>(
                        builder: (context, value, child) {
                      return SearchButtonWidget(onPressed: () {
                        if (value.origin != null && value.destination != null) {
                          eventBus.fire(RouteEvent(
                              origin: value.origin!,
                              destination: value.destination!));
                          setState(() {
                            searchState = "searching";
                          });
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
                      });
                    })))
          ],
        ),
        bottomSheet: Visibility(
          visible:
              !widget._addressSearchFocus.hasFocus && searchState != "waiting",
          child: BottomSheet(
              onClosing: () {},
              showDragHandle: true,
              constraints:
                  BoxConstraints(minWidth: MediaQuery.of(context).size.width),
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              builder: (context) {
                return SizedBox(
                    height: 200,
                    child: Navigator(
                      onGenerateRoute: (settings) {
                        WidgetBuilder builder;
                        switch (settings.name) {
                          case '/':
                            builder = (context) {
                              return StreamBuilder(
                                  stream: GetIt.instance<RouteManager>()
                                      .routeStream,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    Map<int, route_entity.Route> routes =
                                        snapshot.data!;
                                    return RouteSelectionWidget(
                                        routes: routes,
                                        onRouteSelect: (route) {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            Navigator.pushNamed(
                                              context,
                                              "/route_details",
                                              arguments: route,
                                            );
                                          });
                                          final routeSelectionNotifier =
                                              Provider.of<
                                                      RouteSelectionNotifier>(
                                                  context,
                                                  listen: false);
                                          routeSelectionNotifier.route = route;
                                          widget.routeManager
                                              .setActiveRoute(route);
                                        });
                                  });
                            };
                            break;
                          case '/route_details':
                            if (settings.arguments is! route_entity.Route) {
                              throw Exception(
                                  'Invalid data for /route_details: ${settings.name}');
                            }
                            builder = (context) {
                              return RouteDetailsWidget(
                                  route:
                                      settings.arguments as route_entity.Route);
                            };
                            break;
                          default:
                            throw Exception('Invalid route: ${settings.name}');
                        }
                        return MaterialPageRoute(
                            builder: builder, settings: settings);
                      },
                    ));
              }),
        ));
  }
}
