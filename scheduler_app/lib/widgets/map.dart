import 'package:scheduler_app/base_classes/subway_service_color.dart';
import 'package:scheduler_app/entities/route.dart' as route_entity;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scheduler_app/entities/leg.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get_it/get_it.dart';

class MapWidget extends StatefulWidget {
  final double defaultCameraZoom = 10;
  final LatLng defaultCameraLatLng = const LatLng(1.35, 103.84);
  final LatLng? origin;
  final LatLng? destination;
  final route_entity.Route? route;
  final SubwayServiceColor subwayServiceColor =
      GetIt.instance<SubwayServiceColor>();

  MapWidget({super.key, this.origin, this.destination, this.route}) {
    print("CREATING MAP");
    print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
  }

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  GoogleMapController? _controller;
  Set<Polyline> _polylines = <Polyline>{};
  Set<Marker> _markers = <Marker>{};

  Set<Polyline> _buildPolylinefromRoute(route_entity.Route? newRoute) {
    print(newRoute?.fare);
    print("BUILDING POLYLINE");
    if (newRoute == null) {
      return <Polyline>{};
    }

    Set<Polyline> newPolylines = <Polyline>{};

    for (Leg leg in newRoute.legs) {
      if (leg.polylineCoordinates.isNotEmpty) {
        final Polyline polyline = Polyline(
          polylineId: PolylineId(leg.duration.toString()),
          points: leg.polylineCoordinates,
          color: leg is RailLeg
              ? widget.subwayServiceColor.fromServiceName(leg.serviceName)!
              : Colors.blue,
          width: 4,
        );
        newPolylines.add(polyline);
      }
    }

    return newPolylines;
  }

  Set<Marker> _buildMarkersfromRoute(route_entity.Route? newRoute) {
    if (newRoute == null) {
      return <Marker>{};
    }

    Set<Marker> newMarkers = <Marker>{};

    newMarkers.add(Marker(
      markerId: const MarkerId("Origin"),
      position: LatLng(newRoute.origin.latitude, newRoute.origin.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
    ));

    newMarkers.add(Marker(
      markerId: const MarkerId("Destination"),
      position:
          LatLng(newRoute.destination.latitude, newRoute.destination.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
    ));

    return newMarkers;
  }

  Set<Marker> _buildMarkersfromLatLng(LatLng? origin, LatLng? destination) {
    Set<Marker> newMarkers = <Marker>{};

    if (origin != null) {
      newMarkers.add(Marker(
        markerId: const MarkerId("Origin"),
        position: LatLng(origin.latitude, origin.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
      ));
    }

    if (destination != null) {
      newMarkers.add(Marker(
        markerId: const MarkerId("Destination"),
        position: LatLng(destination.latitude, destination.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
      ));
    }

    return newMarkers;
  }

  CameraUpdate _buildCameraUpdate() {
    if (_polylines.isNotEmpty) {
      print("Building camera update from polylines");
      return _buildCameraUpdateFromPolyline(_polylines);
    } else if (widget.route != null) {
      print("Building camera update from route");
      return _buildCameraUpdateFromRoute(widget.route!);
    } else if (widget.origin != null || widget.destination != null) {
      print("Building camera update from LatLng");
      return _buildCameraUpdateFromLatLng(widget.origin, widget.destination);
    } else {
      print("Building default camera update");
      return CameraUpdate.newLatLngZoom(
          widget.defaultCameraLatLng, widget.defaultCameraZoom);
    }
  }

  CameraUpdate _buildCameraUpdateFromPolyline(Set<Polyline> polylines) {
    List<LatLng> points = <LatLng>[];

    for (Polyline polyline in polylines) {
      points.addAll(polyline.points);
    }

    LatLngBounds? bounds = _boundsFromLatLngList(points);
    return CameraUpdate.newLatLngBounds(bounds, 50);
  }

  CameraUpdate _buildCameraUpdateFromRoute(route_entity.Route route) {
    LatLng origin = LatLng(route.origin.latitude, route.origin.longitude);
    LatLng destination =
        LatLng(route.destination.latitude, route.destination.longitude);

    return _buildCameraUpdateFromLatLng(origin, destination);
  }

  CameraUpdate _buildCameraUpdateFromLatLng(
      LatLng? origin, LatLng? destination) {
    List<LatLng> points = [origin, destination]
        .where((item) => item != null)
        .cast<LatLng>()
        .toList();

    if (points.length == 1) {
      return CameraUpdate.newLatLngZoom(points[0], 15);
    }

    LatLngBounds? bounds = _boundsFromLatLngList(points);
    return CameraUpdate.newLatLngBounds(bounds, 50);
  }

  Set<Marker> _buildMarkers() {
    if (widget.route != null) {
      return _buildMarkersfromRoute(widget.route);
    } else if (widget.origin != null || widget.destination != null) {
      return _buildMarkersfromLatLng(widget.origin, widget.destination);
    } else {
      return <Marker>{};
    }
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);

    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }

    return LatLngBounds(
      northeast: LatLng(x1!, y1!),
      southwest: LatLng(x0!, y0!),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _polylines = _buildPolylinefromRoute(widget.route);
      _markers = _buildMarkers();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller != null) {
        _controller!.animateCamera(_buildCameraUpdate());
      }
    });
  }

  @override
  void didUpdateWidget(MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.route == oldWidget.route &&
        widget.origin == oldWidget.origin &&
        widget.destination == oldWidget.destination) return;

    setState(() {
      _polylines = _buildPolylinefromRoute(widget.route);
      _markers = _buildMarkers();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller != null) {
        _controller!.animateCamera(_buildCameraUpdate());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("BUILDING MAP");
    print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
    return GoogleMap(
        initialCameraPosition: CameraPosition(
            target: widget.defaultCameraLatLng, zoom: widget.defaultCameraZoom),
        polylines: _polylines,
        markers: _markers,
        zoomControlsEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(
            () => EagerGestureRecognizer(),
          ),
        });
  }
}
