import 'package:chat_app/auth/firebase_auth_service.dart';
import 'package:chat_app/models/defect.dart';
import 'package:chat_app/models/list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ListProvider with ChangeNotifier {
  List<ListItem> _listItem = [];

  List<ListItem> get allListItem => _listItem;

  void addItem(ListItem item) {
    print("item : $item");
    _listItem.add(item);
    notifyListeners();
  }

  void deleteItem(ListItem item) {
    _listItem.remove(item);
    notifyListeners();
  }

  List<Defects> defect = [];
  void callDefect() async{
    await FirebaseAuthService.getAllMessages().listen((snapshot) {
      defect = List.generate(
          snapshot.docs.length, (index) =>
          Defects.fromMap(snapshot.docs[index].data())
      );
    });
    print("Firebase data : $defect");
    notifyListeners();
  }
}
