import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ListProvider with ChangeNotifier {
  List<Widget> list = [];

  void addItem(Widget item) {
    list.add(item);
    notifyListeners();
  }

  void deleteItem(int index) {
    list.removeAt(index);
    notifyListeners();
  }
}
