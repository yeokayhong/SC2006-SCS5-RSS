import 'package:flutter/material.dart';
import 'package:scheduler_app/entities/legtype_entity.dart';
import 'package:scheduler_app/widgets/legs_widget_methods.dart';
import 'package:scheduler_app/entities/step_entity.dart' as s;

class WalkLegWidget extends StatelessWidget {
  late final List<s.Step> steps;
  WalkLegWidget({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return LegsWidget.buildStepList(steps);
  }
}
