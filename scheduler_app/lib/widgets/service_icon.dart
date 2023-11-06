import 'package:scheduler_app/base_classes/subway_service_color.dart';
import 'package:scheduler_app/entities/leg.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ServiceIconWidgetFactory {
  static ServiceIconWidget fromLeg(Leg leg) {
    switch (leg.runtimeType) {
      case BusLeg:
        return BusServiceIconWidget(leg: leg);
      case RailLeg:
        return RailServiceIconWidget(leg: leg);
      // case TramLeg:
      //   return TramServiceIconWidget(leg: leg);
      case WalkLeg:
        return WalkServiceIconWidget(leg: leg);
      default:
        throw Exception("Invalid service name ${leg.serviceName}");
    }
  }
}

abstract class ServiceIconWidget extends StatelessWidget {
  final Leg leg;

  const ServiceIconWidget({super.key, required this.leg});
}

class BusServiceIconWidget extends ServiceIconWidget {
  const BusServiceIconWidget({super.key, required Leg leg}) : super(leg: leg);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            child: Text(leg.serviceName,
                style: const TextStyle(color: Colors.white, fontSize: 12))));
  }
}

class RailServiceIconWidget extends ServiceIconWidget {
  final SubwayServiceColor subwayServiceColor =
      GetIt.instance<SubwayServiceColor>();

  RailServiceIconWidget({super.key, required Leg leg}) : super(leg: leg);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: subwayServiceColor.fromServiceName(leg.serviceName),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            child: Text(leg.serviceName,
                style: const TextStyle(color: Colors.white, fontSize: 12))));
  }
}

class TramServiceIconWidget extends ServiceIconWidget {
  const TramServiceIconWidget({super.key, required Leg leg}) : super(leg: leg);

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.directions_subway, color: Colors.green);
  }
}

class WalkServiceIconWidget extends ServiceIconWidget {
  const WalkServiceIconWidget({super.key, required Leg leg}) : super(leg: leg);

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.directions_walk, color: Colors.black, size: 18);
  }
}
