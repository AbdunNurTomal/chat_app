import 'dart:convert';

import 'package:chat_app/auth/firebase_auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckFirestoreData{

  //return Firestore.instance
  //    .collection("users")
  //    .where("userEmail", isEqualTo: email)
  //    .getDocuments()
  //    .catchError((e) {
  //print(e.toString());
  //});
  static Future<bool> checkPhoneExists(String phone) async{
    print("checkPhoneExists>>");
    QuerySnapshot _query = await FirebaseFirestore.instance
        .collection("users")
        .where('phone', isEqualTo: phone)
        .get()
        .catchError((e) {
          print(e.toString());
        });
    return _query.docs.isNotEmpty;
    //(_query.docs.isNotEmpty)?true:false;
  }
  static Future<bool> checkEmailExists(String email) async{
    print("checkEmailExists>>");
    QuerySnapshot _query = await FirebaseFirestore.instance
        .collection("users")
        .where('email', isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
    return _query.docs.isNotEmpty;
    //(_query.docs.isNotEmpty)?true:false;
  }
}