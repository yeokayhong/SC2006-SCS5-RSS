import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scheduler_app/concern_manager.dart';

class LtaApi {
  // Base URL for LTA API
  static const baseUrl = "http://datamall2.mytransport.sg/ltaodataservice";

  // Your API Key for LTA API
  static const apiKey = "ny0Dap+1QuuKciIleI3KIg==";

  // ...

  static List<Concern> queryTrainServiceDisruption() {
    return [];
  }

  static List<Concern> queryCrowdedStations() {
    return [];
  }
  // Method to get estimated waiting time for a specific bus stop and service number
  static Future<double> getEstimatedWaitingTime({
    required String busStopCode,
    String serviceNo = "",
  }) async {
    final Uri url = Uri.parse('$baseUrl/BusArrivalv2?BusStopCode=$busStopCode&ServiceNo=$serviceNo');

    final Map<String, String> headers = {
      'AccountKey': apiKey,
    };

    try {
      final http.Response response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> services = jsonResponse['Services'];

        if (services.isNotEmpty) {
          final Map<String, dynamic> firstBus = services[0];
          final String estimatedArrival = firstBus['NextBus']['EstimatedArrival'];

          final DateTime estimatedArrivalTime = DateTime.parse(estimatedArrival);
          final DateTime now = DateTime.now();
          final Duration waitingTime = estimatedArrivalTime.difference(now);

          final double waitingMinutes = waitingTime.inMinutes.toDouble();
          return waitingMinutes;
        } else {
          throw Exception('No bus services available at the moment.');
        }
      } else {
        throw Exception('Failed to fetch estimated waiting time.');
      }
    } catch (e) {
      throw Exception('Failed to get estimated waiting time: $e');
    }
  }

  // ...
}
