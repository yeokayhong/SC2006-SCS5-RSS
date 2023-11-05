import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scheduler_app/managers/route_manager.dart';
import 'package:scheduler_app/entities/route_entity.dart' as r;
import 'package:scheduler_app/entities/duration.dart' as d;
import 'package:scheduler_app/screens/route_details.dart';

class RouteSelectionPage extends StatefulWidget {
  const RouteSelectionPage({super.key});

  @override
  State<RouteSelectionPage> createState() => _RouteSelectionPageState();
}

class _RouteSelectionPageState extends State<RouteSelectionPage> {
  GetIt getIt = GetIt.instance;
  late Stream<Map<int, r.Route>> routeStream;

  @override
  void initState() {
    super.initState();
    routeStream = getIt<RouteManager>().routeStream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Route Selection"),
        actions: [
          IconButton(
            onPressed: () {
              GetIt.instance<RouteManager>().calculateAffectedRoutes();
            },
            icon: Icon(Icons.warning_amber),
          )
        ],
      ),
      body: StreamBuilder<Map<int, r.Route>>(
        stream: routeStream,
        builder: (context, snapshot) {
          debugPrint(
              "Snapshot State for Route Selection: ${snapshot.connectionState}");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No routes available.'),
            );
          } else {
            final routes = snapshot.data;
            debugPrint("Printing Stream Data: $routes");
            return ListView.builder(
              itemCount: routes!.length,
              itemBuilder: (context, index) {
                final routeKey = routes.keys.elementAt(index);
                r.Route routeValue = routes[routeKey]!;
                // If there is concern the color should be red

                if (routeValue.isThereConcern()) {
                  return ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    leading: CircleAvatar(
                      backgroundColor: Colors.redAccent,
                      child: Text(routeKey.toString(), // Route index as string
                          style: TextStyle(color: Colors.white)),
                    ),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Duration: ${d.Duration.convertDurationToMin(routeValue.duration.totalDuration) + routeValue.additionalTime} minutes',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                            width: 8.0), // Spacing between text and indicator
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Text(
                            'Affected',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fare(SGD): ${routeValue.fare}', // Assuming fare is a field on r.Route
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,
                        size: 20.0, color: Colors.redAccent),
                    onTap: () {
                      // Perform actions like navigation
                      debugPrint("Selected Route $routeKey");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RouteDetailsPage(route: routeValue),
                        ),
                      );
                    },
                  );
                } else {
                  return ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(routeKey.toString(), // Route index as string
                          style: TextStyle(color: Colors.white)),
                    ),
                    title: Text(
                      'Duration: ${d.Duration.convertDurationToMin(routeValue.duration.totalDuration)} minutes', // Assuming duration is a field on r.Route
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fare(SGD): ${routeValue.fare}', // Assuming fare is a field on r.Route
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,
                        size: 20.0, color: Colors.blueAccent),
                    onTap: () {
                      // Perform actions like navigation
                      debugPrint("Selected Route $routeKey");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RouteDetailsPage(route: routeValue),
                        ),
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
