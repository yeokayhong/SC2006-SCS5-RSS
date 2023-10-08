import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scheduler_app/constants.dart';

// class should be defined on server side for security purposes
class OneMapAPI {
  // Get Authentication Access Token
  Future<String> fetchToken() async {
    final url = "https://www.onemap.gov.sg/api/auth/post/getToken";
    final payload = {
      "email": Constants.oneMapEmail,
      "password": Constants.oneMapPassword
    };

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(payload),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      debugPrint(response.body);
      String accessToken = jsonDecode(response.body)["access_token"];
      debugPrint(accessToken);
      return accessToken;
    } else {
      throw Exception('Failed to get token');
    }
  }

  // get Routes for Public Transport (MRT, Bus)
  static Future<Map<String, dynamic>> getRoutesPT(
      {required String accessToken,
      required String start,
      required String end,
      required String routeType,
      required String date,
      required String time,
      required String mode,
      String maxWalkDistance = "1000",
      String numItineraries = "3"}) async {
    // send request
    final Uri url =
        Uri.https('www.onemap.gov.sg', '/api/public/routingsvc/route', {
      'start': start,
      'end': end,
      'routeType': routeType,
      'date': date,
      'time': time,
      'mode': mode,
      'maxWalkDistance': maxWalkDistance,
      'numItineraries': numItineraries,
    });

    final Map<String, String> headers = {'Authorization': accessToken};

    final http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      // get response and decode it
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      throw Exception('Failed to fetch routes');
    }
  }

  // get Routes for Walk, Drive, Cycle
}
