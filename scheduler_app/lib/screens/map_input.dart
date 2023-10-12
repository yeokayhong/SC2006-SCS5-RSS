import 'package:flutter/material.dart';
import 'screens_barrel.dart';

class MapInputPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map Page')),
      body: Column(
        children: [
          Expanded(child: Placeholder()), // This is the placeholder map
          TextField(decoration: InputDecoration(labelText: 'Origin')),
          TextField(decoration: InputDecoration(labelText: 'Destination')),
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
