import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'screens_barrel.dart';
import 'package:scheduler_app/widgets/map.dart';
import 'package:scheduler_app/entities/route_entity.dart' as r;

class MapInputPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map Page')),
      body: Column(
        children: [
          // temporarily substitute values in for testing
          Expanded(
            child: MapWidget(
              source: LatLng(1.320981, 103.84415),
              dest: LatLng(1.31875833025, 103.846554958),
              route: r.Route(),
            ),
          ),
          const TextField(decoration: InputDecoration(labelText: 'Origin')),
          const TextField(
            decoration: InputDecoration(labelText: 'Destination'),
          ),
          ElevatedButton(
            onPressed: () {
              _showRouteOptions(context);
            },
            child: Text('Show Result'),
          )
        ],
      ),
    );
  }

  void _showRouteOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Route options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Route 1'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RouteDetailsPage(routeNumber: 1),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Route 2'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RouteDetailsPage(routeNumber: 2),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Route 3'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RouteDetailsPage(routeNumber: 3),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
