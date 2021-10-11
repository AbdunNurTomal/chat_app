import 'dart:async';

import 'package:chat_app/models/list_image_item.dart';
import 'package:chat_app/models/list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ListProvider with ChangeNotifier {
  final List<ListItem> _listItem = [];
  List<ListItem> get allListItem => _listItem;

  bool isLoading = false;
  bool generateReportPDF = false;
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
  void showBtnDownloadPDF(bool generatePDF) {
    generateReportPDF = generatePDF;
    notifyListeners();
  }

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


  // bool isEditShadow = false;
  // void showShadowImageEdit(bool checkShadow) {
  //   isEditShadow = checkShadow;
  //   notifyListeners();
  // }
  void editItem(ListItem oldListItem, ListItem newListItem) {
    if(oldListItem.id == newListItem.id) {
      oldListItem.itemValue = newListItem.itemValue;
      oldListItem.item = newListItem.item;
      oldListItem.images = newListItem.images;
      // oldListItem.edited = newListItem.edited;
      oldListItem.createdTime = newListItem.createdTime;
    }
    notifyListeners();
  }

  void deleteItem(ListItem item) {
    _listItem.remove(item);
    notifyListeners();
  }
}
