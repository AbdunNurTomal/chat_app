
import 'dart:io';
import 'package:chat_app/auth/firebase_auth_service.dart';

import 'list_image_item.dart';

class Defects {
  String itemNumber;
  String itemName;

  Defects({required this.itemNumber,required this.itemName});

  factory Defects.fromMap(Map<String, dynamic> data) => Defects(
    itemNumber: data["item_number"],
    itemName: data["item_name"],
  );

  static List<Defects> fromMapList(List? list) {
    return list!.map((item) => Defects.fromMap(item)).toList();
  }
  String defectsAsString() {
    return '#${itemNumber} ${itemName}';
  }
  bool defectFilterByNumber(String? filter) {
    return itemNumber.toString().contains(filter!);
  }
  bool isEqual(Defects model) {
    return itemNumber == model.itemNumber;
  }

  Map<String, dynamic> toMap() {
    return {
      'item_number': itemNumber,
      'item_name': itemName,
    };
  }

  @override
  String toString() => itemName;
}

class DefectData{
  static List<Defects> defect = [];
  // List<Defects> get allListDefect => defect;

  static void callDefect() async{
    FirebaseAuthService.getAllMessages().listen((snapshot) {
      defect = List.generate(
          snapshot.docs.length, (index) =>
          Defects.fromMap(snapshot.docs[index].data())
      );
    });
  }

  static void addDefectItem(Defects filter) {
    //print("All Defect items $filter : $defect");
    defect.add(Defects(itemNumber: filter.itemNumber, itemName: filter.itemName));
    //print("After deleted : $defect");
  }

  static void deleteDefectItem(String filter) {
    //print("All Defect items $filter : $defect");
    defect.removeWhere((item) => item.itemName == filter);
    //print("After deleted : $defect");
  }
}

class DefectImageData{
  static final List<ListImagesItem> _listImagesItem = [];
  static List<ListImagesItem> get allListImagesItem => _listImagesItem;

  static void addImageItem(ListImagesItem item) {
    _listImagesItem.add(item);
  }

  static void updateImageItem(String item) {

    print("need to update >>>>> $item");
    for (var element in allListImagesItem) {
      if(element.newImgName == item){
        element.isImgEdited = true;
      }
      print(">>>>> ${element.newImgName}");
    }
  }

  // static void callDefect() async{
  //   FirebaseAuthService.getAllMessages().listen((snapshot) {
  //     defect = List.generate(
  //         snapshot.docs.length, (index) =>
  //         Defects.fromMap(snapshot.docs[index].data())
  //     );
  //   });
  // }


  void deleteImageItem(String filter) {
    _listImagesItem.removeWhere((item) => item.newImgName == filter);
  }
}
