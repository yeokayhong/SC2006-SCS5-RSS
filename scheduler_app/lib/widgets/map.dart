// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scheduler_app/constants.dart';
import 'package:scheduler_app/managers/route_manager.dart';
import 'package:scheduler_app/entities/route.dart' as r;

class MapWidget extends StatefulWidget {
  LatLng source;
  LatLng dest;
  r.Route route;

  MapWidget(
      {super.key,
      required this.source,
      required this.dest,
      required this.route});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  // default camera position
  static const double cameraZoom = 14.5;

  List<LatLng> polylineCoordinates = [];

  // unitTest list
  List<List<num>> decodedPolyLines = [];

  // void processLegGeometry(String legGeometry) {
  //   // get the leg geometry
  //   // decode leg geometry
  //   setState(() {
  //     decodedPolyLines = decodePolyline(legGeometry);
  //   });
  // }

  // void getPolyPoints() async {
  //   // server should return a list of legs that contains a list of points based on decoded leg geometry
  //   List<String> legGeometryList;
  //   processLegGeometry(
  //       "s~`GmayxRa@a@VSDE@CFEHIPOBC@CA?@A\\Y@CnAmAHIBCDEDEDCDCJGFCJCFAHALAh@El@GXCXCF?TCAGC[?EB?JCPA@A@A?AEa@UaAAMB?");
  //   for (var i = 0; i < decodedPolyLines.length; i++) {
  //     polylineCoordinates.add(LatLng(decodedPolyLines[i][0].toDouble(),
  //         decodedPolyLines[i][1].toDouble()));
  //   }

  //   // empty setState rebuilds the whole widget tree, ensuring the polylines are drawn.
  //   debugPrint("Coordinates are: " + polylineCoordinates.toString());
  //   setState(() {});
  // }

  @override
  void initState() {
    // getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.source,
        zoom: cameraZoom,
      ),
      polylines: {
        Polyline(
          polylineId: PolylineId("route"),
          points: polylineCoordinates,
          color: Constants.primaryColor,
          width: 4,
        )
      },
      markers: {
        Marker(
          markerId: MarkerId("source"),
          position: widget.source,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
        Marker(
            markerId: MarkerId("dest"),
            position: widget.dest,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed))
      },
      zoomControlsEnabled: false,
    );
  }
}
