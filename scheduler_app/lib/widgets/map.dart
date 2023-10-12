import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  LatLng source;
  LatLng dest;
  MapWidget({super.key, required this.source, required this.dest});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  // default camera position
  static const double cameraZoom = 14.5;

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.source,
        zoom: cameraZoom,
      ),
      markers: {
        Marker(
          markerId: MarkerId("Default"),
          position: widget.source,
        )
      },
    );
  }
}
