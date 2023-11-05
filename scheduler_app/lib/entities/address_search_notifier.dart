import 'package:scheduler_app/entities/address.dart';
import 'package:flutter/material.dart';

class AddressSearchNotifier with ChangeNotifier {
  Address? _origin;
  Address? _destination;

  Address? get origin => _origin;
  Address? get destination => _destination;

  set origin(Address? newOrigin) {
    _origin = newOrigin;
    notifyListeners();
  }

  set destination(Address? newDestination) {
    _destination = newDestination;
    notifyListeners();
  }
}
