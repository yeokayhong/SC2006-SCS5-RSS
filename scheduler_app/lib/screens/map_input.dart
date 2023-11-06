import 'package:scheduler_app/entities/route_selection_notifier.dart';
import 'package:scheduler_app/entities/address_search_notifier.dart';
import 'package:scheduler_app/entities/route.dart' as route_entity;
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
  bool addressBarFocused = false;
  bool isWrongInput = false;
  bool isLoading = false;

  void handleOriginChange(Address newOrigin) {
    Future.microtask(() {
      final addressSearchNotifier =
          Provider.of<AddressSearchNotifier>(context, listen: false);
      debugPrint(
          "Origin selected: ${newOrigin.latitude}, ${newOrigin.longitude}");
      addressSearchNotifier.origin = newOrigin;
    });
  }

  void handleDestinationChange(Address newDestination) {
    Future.microtask(() {
      debugPrint(
          "Destination selected: ${newDestination.latitude}, ${newDestination.longitude}");
      final addressSearchNotifier =
          Provider.of<AddressSearchNotifier>(context, listen: false);
      addressSearchNotifier.destination = newDestination;
    });
  }

  void handleRouteChange(route_entity.Route newRoute) {
    Future.microtask(() {
      final routeSelectionNotifier =
          Provider.of<RouteSelectionNotifier>(context, listen: false);
      routeSelectionNotifier.selectedRoute = newRoute;
    });
  }

  void handleRouteSelect(route_entity.Route newRoute) {
    Future.microtask(() {
      widget.routeManager.setActiveRoute(newRoute);
    });
  }

  @override
  void initState() {
    super.initState();
    final routeSelectionNotifier =
        Provider.of<RouteSelectionNotifier>(context, listen: false);
    widget.routeManager.routeStream.listen((event) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      routeSelectionNotifier.routes = event;
      routeSelectionNotifier.activeRoute = widget.routeManager.getActiveRoute();
    });
    widget._addressSearchFocus.addListener(() {
      setState(() {
        addressBarFocused = widget._addressSearchFocus.hasFocus;
      });
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    widget.routeManager.cancelTimers();
    widget._addressSearchFocus.dispose();
  }

  @override
  void dispose() {
    super.dispose();
    widget.routeManager.cancelTimers();
    widget._addressSearchFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RouteSelectionNotifier>(
        builder: (context, routeState, child) {
      return WillPopScope(
          onWillPop: () {
            if (routeState.activeRoute != null) {
              widget.routeManager.setActiveRoute(null);
              return Future.value(false);
            } else if (routeState.routes != null &&
                routeState.routes!.isNotEmpty) {
              routeState.selectedRoute = null;
              routeState.routes = null;
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
              body: Stack(
                children: [
                  Consumer<AddressSearchNotifier>(
                      builder: (context, addressState, child) {
                    return MapWidget(
                        route: routeState.selectedRoute,
                        origin: Address.toLatLng(addressState.origin),
                        destination:
                            Address.toLatLng(addressState.destination));
                  }),
                  Consumer<AddressSearchNotifier>(
                      builder: (context, value, child) {
                    return Focus(
                        focusNode: widget._addressSearchFocus,
                        child: AddressSearchWidget(
                            initialOrigin: value.origin,
                            initialDestination: value.destination,
                            onOriginChanged: handleOriginChange,
                            onDestinationChanged: handleDestinationChange));
                  }),
                  Positioned(
                      left: 5,
                      right: 5,
                      bottom: 5,
                      child: Visibility(
                          visible: (routeState.routes == null ||
                                  routeState.routes!.isEmpty) &&
                              !addressBarFocused,
                          child: Consumer<AddressSearchNotifier>(
                              builder: (context, value, child) {
                            return SearchButtonWidget(
                                onPressed: () {
                                  if (value.origin != null &&
                                      value.destination != null) {
                                    eventBus.fire(RouteQueryEvent(
                                        origin: value.origin!,
                                        destination: value.destination!));
                                    setState(() {
                                      isLoading = true;
                                    });
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                      isWrongInput = true;
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        if (mounted) {
                                          setState(() {
                                            isWrongInput = false;
                                          });
                                        }
                                      });
                                    });
                                  }
                                },
                                isLoading: isLoading,
                                isError: isWrongInput);
                          })))
                ],
              ),
              bottomSheet: Consumer<RouteSelectionNotifier>(
                  builder: (context, routeState, child) {
                return Visibility(
                  visible: !addressBarFocused &&
                      routeState.routes != null &&
                      routeState.routes!.isNotEmpty,
                  child: BottomSheet(
                      onClosing: () {},
                      showDragHandle: true,
                      constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width),
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      builder: (context) {
                        if (routeState.activeRoute == null) {
                          return SizedBox(
                              height: 150,
                              child: RouteSelectionWidget(
                                  initialRoute: routeState.selectedRoute,
                                  routes: routeState.routes!,
                                  onRouteChange: handleRouteChange,
                                  onRouteSelect: handleRouteSelect));
                        } else {
                          return SizedBox(
                              height: 200,
                              child: SingleChildScrollView(
                                  child: RouteDetailsWidget(
                                      route: routeState.activeRoute!)));
                        }
                      }),
                );
              })));
    });
  }
}
