import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Users {
  String? displayName;
  String? userEmail;
  String? userPhone;
  String? userPassword;
  String? userRole;
  String? userLastSeen;
  String? userPresence;
  String? userProfilePicUrl;
  String? userUid;
  String? userDesignation;
  String? createdDateTime;

  //Users({
  //  required this.displayName,
  //  required this.userEmail,
  //  this.userPhone = '',
  //  this.userPassword = '',
  //  this.userRole = '',
  //  this.userLastSeen = '',
  //  this.userPresence = '',
  //  this.userProfilePicUrl = '',
  //  this.userUid = '',
  //  this.userDesignation = '',
  //  this.createdDateTime = '',
  //});
  Users(
      {this.displayName,
      this.userEmail,
      this.userPassword,
      this.userUid,
      this.userRole});

  //Users({userPassword, displayName, userEmail, userUid});

  //Users.fromMap(Map<String, dynamic> data) {
  //  this.displayName = data["display_name"];
  //  this.userEmail = data["email"];
  //  this.userPhone = data["phone"];
  //  this.userPassword = data["password"];
  //  this.userRole = data["role"];
  //  this.userLastSeen = data["last_seen"];
  //  this.userPresence = data["presence"];
  //  this.userProfilePicUrl = data["profile_pic"];
  //  this.userDesignation = data["designation"];
  //  this.userUid = data["uid"];
  //  this.createdDateTime = data["created_date_time"];
  //}

  //factory Users.fromMap(Map<String, dynamic> data) => Users(
  //      displayName: data["display_name"],
  //      userEmail: data["email"],
  //      userPhone: data["phone"],
  //      userPassword: data["password"],
  //      userRole: data["role"],
  //      userLastSeen: data["last_seen"],
  //      userPresence: data["presence"],
  //      userProfilePicUrl: data["profile_pic"],
  //      userDesignation: data["designation"],
  //      userUid: data["uid"],
  //      createdDateTime: data["created_date_time"],
  //    );
  factory Users.fromMap(Map<String, dynamic> data) => Users(
        displayName: data["display_name"],
        userEmail: data["email"],
        userPassword: data["password"],
        userUid: data["uid"],
        userRole: data["role"],
      );

  //factory Users.fromMap(Map<String, dynamic> data) {
  //  print(data["displayName"]);
  //  return Users(
  //    displayName: data["displayName"],
  //    userEmail: data["email"],
  //    userPassword: data["password"],
  //    userUid: data["uid"],
  //  );
  //}

  //Map<String, dynamic> toMap() {
  //  return {
  //    'display_name': displayName,
  //    'email': userEmail,
  //    'phone': userPhone,
  //    'password': userPassword,
  //    'role': userRole,
  //    'last_seen': userLastSeen,
  //    'presence': userPresence,
  //    'profile_pic': userProfilePicUrl,
  //    'designation': userDesignation,
  //    'uid': userUid,
  //    'created_date_time': createdDateTime
  //  };
  //}

  Map<String, dynamic> toMap() {
    return {
      'display_name': displayName,
      'email': userEmail,
      'password': userPassword,
      'role': userRole,
      'uid': userUid,
    };
  }
}

/*
class UserModel {
  final String id;
  final DateTime createdAt;
  final String name;
  final String avatar;

  UserModel({this.id, this.createdAt, this.name, this.avatar});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return UserModel(
      id: json["id"],
      createdAt:
      json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      name: json["name"],
      avatar: json["avatar"],
    );
  }

  static List<UserModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => UserModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///this method will prevent the override of toString
  bool userFilterByCreationDate(String? filter) {
    return this.createdAt.toString().contains(filter!);
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(UserModel model) {
    return this?.id == model?.id;
  }

  @override
  String toString() => name;
}

 */
