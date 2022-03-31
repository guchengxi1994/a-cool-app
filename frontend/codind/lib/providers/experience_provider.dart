import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class ExperienceController extends ChangeNotifier {
  Map<String, List<Tuple2>> _data = {"edu": [], "work": [], "abi": []};

  List<Tuple2> get edu => _data["edu"]!;
  List<Tuple2> get work => _data["work"]!;
  List<Tuple2> get abi => _data["abi"]!;

  addValue(String keyName, int index, String value) {
    if (_data.keys.contains(keyName)) {
      _data[keyName]!.add(Tuple2(index, value));
      notifyListeners();
    }
  }

  removeValue(String value, int index) {
    if (_data.keys.contains(value)) {
      // _data[value]!.removeAt(index);
      var _index = _data[value]!.indexWhere((element) {
        return element.item1 == index;
      });

      if (_index != -1) {
        _data[value]!.removeAt(index);
        notifyListeners();
      }
    }
  }
}
