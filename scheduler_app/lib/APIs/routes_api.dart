import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scheduler_app/constants.dart';

// service class for requesting Routes
class RoutesAPI {
  // get Routes for Public Transport (MRT, Bus)
  static Future<Map<String, dynamic>> getRoutes(
      {required String start,
      required String end,
      required String routeType,
      required String date,
      required String time,
      String mode = "TRANSIT",
      String maxWalkDistance = "1000",
      String numItineraries = "3"}) async {
    // send request
    final Uri url = Uri.http(Constants.serverRouteRequest, '/get_routes_pt', {
      'start': start,
      'end': end,
      'routeType': routeType,
      'date': date,
      'time': time,
      'mode': mode,
      'maxWalkDistance': maxWalkDistance,
      'numItineraries': numItineraries,
    });

    final http.Response response = await http.get(url);
    Map<String, dynamic> jsonResponse;
    if (response.statusCode == 200) {
      // get response and decode it
      jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      jsonResponse = {"error": "Unable to get routes."};
      return jsonResponse;
    }
  }
}
