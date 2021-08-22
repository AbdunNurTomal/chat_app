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

  Users();

  Users.fromMap(Map<String, dynamic>? data) {
    displayName = data!["display_name"];
    userEmail = data["email"];
    userPhone = data["phone"];
    userPassword = data["password"];
    userRole = data["role"];
    userLastSeen = data["last_seen"];
    userPresence = data["presence"];
    userProfilePicUrl = data["profile_pic"];
    userDesignation = data["designation"];
    userUid = data["uid"];
    createdDateTime = data["created_date_time"];
  }

  Map<String, dynamic> toMap() {
    return {
      'display_name': displayName,
      'email': userEmail,
      'phone': userPhone,
      'password': userPassword,
      'role': userRole,
      'last_seen': userLastSeen,
      'presence': userPresence,
      'profile_pic': userProfilePicUrl,
      'designation': userDesignation,
      'uid': userUid,
      'created_date_time': createdDateTime
    };
  }
}
