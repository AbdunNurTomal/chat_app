import 'package:intl/intl.dart';

class Users {
  String firstName = '';
  String lastName = '';
  String userEmail = '';
  num userPhone = 0;
  String userPassword = '';
  String userRole = '';
  String userLastSeen = '';
  String userPresence = '';
  String userProfilePicUrl = '';
  String userUid = '';
  String createdDateTime = '';

  Users({
    firstName,
    lastName,
    userEmail,
    userPhone,
    userPassword,
    userRole,
    userLastSeen,
    userPresence,
    userProfilePicUrl,
    userUid,
    createdDateTime,
  });

  factory Users.fromMap(Map<String, dynamic> userJson) {
    return Users(
      firstName: userJson["first_name"],
      lastName: userJson["last_name"],
      userEmail: userJson["email"],
      userPhone: userJson["phone"],
      userPassword: userJson["password"],
      userRole: userJson["role"],
      userLastSeen: userJson["last_seen"],
      userPresence: userJson["presence"],
      userProfilePicUrl: userJson["profile_pic"],
      userUid: userJson["uid"],
      createdDateTime: userJson["created_date_time"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': userEmail,
      'phone': userPhone,
      'password': userPassword,
      'role': userRole,
      'last_seen': userLastSeen,
      'presence': userPresence,
      'profile_pic': userProfilePicUrl,
      'uid': userUid,
      'created_date_time': createdDateTime
    };
  }
}
