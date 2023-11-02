// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scheduler_app/entities/route_entity.dart' as r;

import '../entities/leg_entity.dart';

class MapWidget extends StatefulWidget {
  late LatLng source;
  late LatLng dest;
  late List<Leg> legs;
  r.Route route;

  MapWidget({super.key, required this.route}) {
    source = LatLng(route.from.lat, route.from.lon);
    dest = LatLng(route.dest.lat, route.dest.lon);
    legs = route.legs;
  }

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  // default camera position
  static const double cameraZoom = 14.5;
  Set<Polyline> polylines = Set<Polyline>();

  void _createPolylineSet(List<Leg> legs) {
    // Define a Set of Polyline objects
    for (Leg leg in legs) {
      if (leg.polylineCoordinates.isNotEmpty) {
        final Polyline polyline = Polyline(
          polylineId: PolylineId("route"),
          points: leg.polylineCoordinates,
          color: Colors.blue, // Replace with your primary color
          width: 4,
        );
        polylines.add(polyline);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    // getPolyPoints();
    super.initState();
    _createPolylineSet(widget.legs);
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.source,
        zoom: cameraZoom,
      ),
      polylines: polylines,
      markers: {
        Marker(
          markerId: MarkerId("source"),
          position: widget.source,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
        Marker(
            markerId: MarkerId("dest"),
            position: widget.dest,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed))
      },
    );
  }
}
