import 'package:flutter/material.dart';

class DynamicList {
  List<Widget> _list = [];
  DynamicList(this._list);

  List get list => _list;
}
