import 'dart:collection';

import 'package:fitness/models/foodsearch.dart';
import 'package:flutter/material.dart';

class CalIntake with ChangeNotifier {
  final List<FoodSearch> _items = [];
  double _totalCals = 0;
  double _totalBurned = 0;
  UnmodifiableListView<FoodSearch> get items => UnmodifiableListView(_items);
  int get totalItems => _items.length;
  double get totalCals => double.parse(_totalCals.toStringAsFixed(2));
  double get totalBurned => _totalBurned;

  void addtoList(FoodSearch foodsearch) {
    _totalCals += foodsearch.calories;
    _items.add(foodsearch);
    notifyListeners();
    print(_totalCals);
  }

  void addtoBurned(double BurnedCal) {
    _totalBurned += BurnedCal;
  }

  void removeItem(int index) {
    _totalCals -= _items[index].calories;
    _items.removeAt(index);
    notifyListeners();
  }
}
