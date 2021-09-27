import 'dart:async';

import 'package:chat_app/auth/firebase_auth_service.dart';
import 'package:chat_app/models/defect.dart';
import 'package:chat_app/models/list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ListProvider with ChangeNotifier {
  List<ListItem> _listItem = [];
  List<ListItem> get allListItem => _listItem;

  bool isLoading = false;
  int circularIndicator = 0;
  // void indicator() {
  //   Timer.periodic(Duration(milliseconds:1000),(_){
  //     if(circularIndicator<101){
  //       circularIndicator++;
  //     }else{
  //       circularIndicator = 0;
  //     }
  //     notifyListeners();
  //   });
  // }

  void showCircularProgress(bool checkLoading) {
    //print("item : $item");
    isLoading = checkLoading;
    notifyListeners();
  }

  void addItem(ListItem item) {
    //print("item : $item");
    _listItem.add(item);
    notifyListeners();
  }

  bool isEditShadow = false;
  void showShadowImageEdit(bool checkShadow) {
    isEditShadow = checkShadow;
    notifyListeners();
  }
  void editItem(ListItem oldListItem, ListItem newListItem) {
    // print("edit item : $newListItem");
    if(oldListItem.id == newListItem.id) {
      // oldListItem.itemValue = newListItem.itemValue;
      // oldListItem.item = newListItem.item;
      oldListItem.images = newListItem.images;
      oldListItem.createdTime = newListItem.createdTime;
    }
    notifyListeners();
  }

  void deleteItem(ListItem item) {
    _listItem.remove(item);
    notifyListeners();
  }
}
