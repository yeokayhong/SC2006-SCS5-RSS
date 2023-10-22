import 'package:flutter/material.dart';
import 'screens_barrel.dart';
import 'package:scheduler_app/widgets/legs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scheduler_app/widgets/map.dart';
import 'package:scheduler_app/entities/route_entity.dart' as r;

class RouteDetailsPage extends StatelessWidget {
  final int routeNumber;

  RouteDetailsPage({required this.routeNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Route #$routeNumber Details')),
      body: Column(
        children: [
          // 60% of the screen for Map
          Expanded(
            flex: 6,
            child: MapWidget(
              source: LatLng(1.320981,
                  103.84415), // You can adjust these coordinates accordingly
              dest: LatLng(1.31875833025, 103.846554958),
              route: r.Route.placeholder(),
            ),
          ),
          // 40% of the screen for travel plan details
          Expanded(
            flex: 4,
            child: LegsWidget(),
          ),
        ],
      ),
    );
  }
}





// ListView(
//         padding: EdgeInsets.all(16),
//         children: [
//           Text('Route #$routeNumber',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//           // Depending on the routeNumber, you can customize the data shown below
//           Text('Travel Time: ~  min(s)'),
//           Text('Waiting Time: ~  min(s) (Train)'),
//           Text('Total Estimated Time: ~ min(s) (Train)'),
//           //Text('Cost: ~ $1.50'),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       SelectedRoutePage(routeNumber: routeNumber),
//                 ),
//               );
//               // Do something when the user selects the route
//             },
//             child: Text('Select Route'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context); // Navigate back to Map Input Page
//             },
//             child: Text('Return'),
//           ),
//         ],
//       ),
