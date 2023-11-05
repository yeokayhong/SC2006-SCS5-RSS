class Stop {
  final String name;
  final double lat;
  final double lon;
  bool isCurrentStop;

  Stop({
    required this.lat,
    required this.lon,
    required this.name,
    this.isCurrentStop = false,
  });

  static Stop create(Map<String, dynamic> stopData, String type) {
    switch (type) {
      case "BUS":
        return BusStop.fromJson(stopData);
      case "SUBWAY":
        return RailStop.fromJson(stopData);
      case "WALK":
        return WalkStop.fromJson(stopData);
      default:
        throw Exception("Invalid stop type");
    }
  }
}

class BusStop extends Stop {
  final String stopCode;
  final int stopIndex;
  final int stopSequence;

  BusStop({
    required double lat,
    required double lon,
    required String name,
    required this.stopCode,
    required this.stopIndex,
    required this.stopSequence,
  }) : super(lat: lat, lon: lon, name: name);

  static BusStop fromJson(Map<String, dynamic> stopData) {
    return BusStop(
      lat: stopData['lat'],
      lon: stopData['lon'],
      name: stopData['name'],
      stopCode: stopData['stopCode'],
      stopIndex: stopData['stopIndex'],
      stopSequence: stopData['stopSequence'],
    );
  }
}

class RailStop extends Stop {
  final String stopCode;
  final int stopIndex;
  final int stopSequence;

  RailStop({
    required double lat,
    required double lon,
    required String name,
    required this.stopCode,
    required this.stopIndex,
    required this.stopSequence,
  }) : super(lat: lat, lon: lon, name: name);

  static RailStop fromJson(Map<String, dynamic> stopData) {
    return RailStop(
      lat: stopData['lat'],
      lon: stopData['lon'],
      name: stopData['name'],
      stopCode: stopData['stopCode'],
      stopIndex: stopData['stopIndex'],
      stopSequence: stopData['stopSequence'],
    );
  }
}

class WalkStop extends Stop {
  WalkStop({
    required double lat,
    required double lon,
    required String name,
  }) : super(lat: lat, lon: lon, name: name);

  static WalkStop fromJson(Map<String, dynamic> stopData) {
    return WalkStop(
      lat: stopData['lat'],
      lon: stopData['lon'],
      name: stopData['name'],
    );
  }
}
