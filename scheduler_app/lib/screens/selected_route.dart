import 'package:flutter/material.dart';

class SelectedRoutePage extends StatelessWidget {
  final int routeNumber;

  SelectedRoutePage({required this.routeNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Selected Route #$routeNumber')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Placeholder(
              fallbackHeight: 200.0), // Placeholder for map showing path
          SizedBox(height: 20),
          Text('Path for Route #$routeNumber',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          // You can fetch the path details for the route using the routeNumber
          SizedBox(height: 20),
          Text('Estimated time remaining: min(s)'),
          // This can be dynamic based on the route selected
        ],
      ),
    );
  }
}
