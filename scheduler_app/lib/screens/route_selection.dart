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
      ),
      body: StreamBuilder<Map<int, r.Route>>(
        stream: routeStream,
        builder: (context, snapshot) {
          debugPrint("Snapshot State: ${snapshot.connectionState}");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No routes available.'),
            );
          }

          final routes = snapshot.data;

          return ListView.builder(
            itemCount: routes!.length,
            itemBuilder: (context, index) {
              final routeKey = routes.keys.elementAt(index);
              r.Route routeValue = routes[routeKey]!;

              return ListTile(
                contentPadding: EdgeInsets.all(16.0),
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text(routeKey.toString(), // Route index as string
                      style: TextStyle(color: Colors.white)),
                ),
                title: Text(
                  'Duration: ${d.Duration.convertDurationToMin(routeValue.duration.totalDuration)} minutes', // Assuming duration is a field on r.Route
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fare(SGD): ${routeValue.fare}', // Assuming fare is a field on r.Route
                      style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                    ),
                  ],
                ),
                trailing: Icon(Icons.arrow_forward_ios,
                    size: 20.0, color: Colors.blueAccent),
                onTap: () {
                  // Perform actions like navigation
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RouteDetailsPage(routeNumber: routeKey),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
