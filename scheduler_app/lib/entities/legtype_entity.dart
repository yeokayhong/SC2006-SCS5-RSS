import 'package:scheduler_app/base_classes/legtype_enum.dart';
import 'package:scheduler_app/entities/step_entity.dart';
import 'package:scheduler_app/entities/stop_entity.dart';

abstract class LegType {
  late LegMode mode;
}

class WalkLeg extends LegType {
  late List<Step> steps;
  WalkLeg({required List<dynamic> stepList}) {
    super.mode = LegMode.WALK;
    // intialize step list
  }
}

class BusLeg extends LegType {
  late List<Stop> stops;
  BusLeg({required List<dynamic> stopList}) {
    super.mode = LegMode.BUS;
    // intialize stop list
  }
}
