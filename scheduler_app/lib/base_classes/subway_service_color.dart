import 'package:flutter/services.dart';
import 'package:csv/csv.dart';

class SubwayServiceColor {
  static SubwayServiceColor? _instance;
  final Map<String, Color> serviceColors = {};

  SubwayServiceColor._internal();

  static Future<SubwayServiceColor> getInstance() async {
    if (_instance == null) {
      var instance = SubwayServiceColor._internal();
      await instance.loadServiceColors();
      _instance = instance;
    }
    return _instance!;
  }

  Future<void> loadServiceColors() async {
    String csvData =
        await rootBundle.loadString("assets/SubwayServiceColors.csv");
    List<List<dynamic>> rowsAsListOfValues =
        const CsvToListConverter().convert(csvData);

    for (List<dynamic> row in rowsAsListOfValues) {
      String serviceName = row[0];
      String hexCode = row[1];
      hexCode = hexCode.replaceAll("#", "0xff");
      Color color = Color(int.parse(hexCode));
      serviceColors[serviceName.toUpperCase()] = color;
    }
  }

  Color? fromServiceName(String serviceName) {
    return serviceColors[serviceName.toUpperCase()];
  }
}
