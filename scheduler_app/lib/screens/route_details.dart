import 'package:flutter/material.dart';
import 'screens_barrel.dart';

class RouteDetailsPage extends StatelessWidget {
  final int routeNumber;

  RouteDetailsPage({required this.routeNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Route #$routeNumber Details')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text('Route #$routeNumber',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          // Depending on the routeNumber, you can customize the data shown below
          Text('Travel Time: ~ 50 mins'),
          Text('Waiting Time: ~ 5 mins (Train)'),
          Text('Total Estimated Time: ~ 55 mins (Train)'),
          //Text('Cost: ~ $1.50'),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SelectedRoutePage(routeNumber: routeNumber),
                ),
              );
              // Do something when the user selects the route
            },
            child: Text('Select Route'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Navigate back to Map Input Page
            },
            child: Text('Return'),
          ),
        ],
      ),
    );
  }
}
