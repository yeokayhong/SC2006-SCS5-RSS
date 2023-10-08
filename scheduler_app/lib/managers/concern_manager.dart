import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';
import 'package:scheduler_app/events.dart';
import 'package:scheduler_app/lta_api.dart';

class ConcernManager {
  final List<Concern> _concerns = [];
  EventBus get eventBus => GetIt.instance<EventBus>();

  void queryConcerns() {
    List<Concern> disruptions = LtaApi.queryTrainServiceDisruption();
    List<Concern> crowded = LtaApi.queryCrowdedStations();

    _updateConcerns(disruptions);
    _updateConcerns(crowded);
  }

  List<Concern> get concerns {
    return _concerns;
  }

  void _updateConcerns(List<Concern> newConcerns) {
    for (Concern newConcern in newConcerns) {
      _addConcern(newConcern);
    }

    for (Concern concern in _concerns) {
      if (newConcerns.contains(concern)) continue;
      if (concern.type == newConcerns[0].type) {
        _removeConcern(concern);
      }
    }
  }

  void _removeConcern(Concern toRemove) {
    if (_concerns.remove(toRemove)) {
      eventBus.fire(ConcernEvent("removed", toRemove));
    }
  }

  void _addConcern(Concern toUpdate) {
    if (_concerns.remove(toUpdate)) {
      _concerns.add(toUpdate);
      eventBus.fire(ConcernEvent("updated", toUpdate));
    } else {
      _concerns.add(toUpdate);
      eventBus.fire(ConcernEvent("added", toUpdate));
    }
  }
}

class Concern {
  String type;
  String service;
  List<String> affectedStops;
  DateTime time;
  String message;

  Concern(
      {required this.type,
      required this.service,
      required this.affectedStops,
      required this.time,
      required this.message});

  @override
  bool operator ==(Object other) {
    if (other is! Concern) {
      return false;
    }
    return type == other.type && service == other.service && time == other.time;
  }

  @override
  int get hashCode => type.hashCode ^ service.hashCode ^ time.hashCode;
}
