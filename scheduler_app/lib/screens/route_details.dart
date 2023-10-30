import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scheduler_app/entities/leg_entity.dart';
import '../managers/route_manager.dart';
import 'screens_barrel.dart';
import 'package:scheduler_app/widgets/legs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scheduler_app/widgets/map.dart';
import 'package:scheduler_app/entities/route_entity.dart' as r;

class RouteDetailsPage extends StatefulWidget {
  final int routeNumber;
  const RouteDetailsPage({super.key, required this.routeNumber});

  @override
  State<RouteDetailsPage> createState() => _RouteDetailsPageState();
}

class _RouteDetailsPageState extends State<RouteDetailsPage> {
  GetIt getIt = GetIt.instance;
  late Stream<Map<int, r.Route>> routeStream;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    routeStream = getIt<RouteManager>().routeStream;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Route #${widget.routeNumber} Details')),
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
              child: Text('Route not available, please search route again.'),
            );
          }

          final route = snapshot.data![widget.routeNumber]!;
          List<Leg> legs = route.legs;

          return ListView.builder(
            itemCount: legs.length,
            itemBuilder: (context, index) {
              final leg = legs[index];

              return LegsWidget(
                leg: leg,
              );
            },
          );
        },
      ),
      // Column(
      //   children: [
      //     // 60% of the screen for Map
      //     Expanded(
      //       flex: 6,
      //       child: MapWidget(
      //         source: LatLng(1.320981,
      //             103.84415), // You can adjust these coordinates accordingly
      //         dest: LatLng(1.31875833025, 103.846554958),
      //         route: r.Route.placeholder(),
      //       ),
      //     ),
      //     // 40% of the screen for travel plan details
      //     Expanded(
      //       flex: 4,
      //       child: LegsWidget(),
      //     ),
      //   ],
      // ),
    );
  }
}
