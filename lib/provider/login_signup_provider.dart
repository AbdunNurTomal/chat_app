import 'package:chat_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginSignupProvider with ChangeNotifier {
  User? _user;
  //User get user => _user;
  get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  Users? _userDetails;
  //Users get userDetails => _userDetails!;
  get userDetails => _userDetails;

  void setUserDetails(Users users) {
    _userDetails = users;
    notifyListeners();
  }

/*
  User? firebaseUser;
  bool isUserLoggedIn = true;
  int userRole = 0;

  late UserProfilePage _currentUserProfile;

  //LoginManager() {
  //  setPropertiesForNullUser();
  //}

  Future<void> init() async {
    // Fetch current user from firebase authentication service
    // You need to setup the app on firebase first
    firebaseUser = FirebaseAuth.instance.currentUser;
    print(firebaseUser!.email);

    // This should be fetched from sharedPref for pre-existing users
    // shouldNotify should be false when called during app init
    //await updateUser(firebaseUser!, shouldPresence: false);
  }

  

/*
  //bool _isLoading = false;
  //String phoneNumber = "";
  //String email = "";
  //String? name;
  //String job = '';
  //String imageUrl = "";
  //String joinedAt = " ";
  //bool _isSameUser = false;
  //void getUserData() async {
  //  try {
  //    _isLoading = true;
  //    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //        .collection('users')
  //        .doc(widget.userID)
  //        .get();
  //    if (userDoc == null) {
  //      return;
  //    } else {
  //      setState(() {
  //        email = userDoc.get('email');
  //        name = userDoc.get('name');
  //        job = userDoc.get('positionInCompany');
  //        phoneNumber = userDoc.get('phoneNumber');
  //        imageUrl = userDoc.get('userImage');
  //        Timestamp joinedAtTimeStamp = userDoc.get('createdAt');
  //        var joinedDate = joinedAtTimeStamp.toDate();
  //        joinedAt = '${joinedDate.year}-${joinedDate.month}-${joinedDate.day}';
  //      });
  //      User? user = _auth.currentUser;
  //      final _uid = user!.uid;
  //      setState(() {
  //        _isSameUser = _uid == widget.userID;
  //      });
  //    }
  //  } catch (eror) {} finally {
  //    _isLoading = false;
  //  }
  //}
*/
  //Future<void> updateUser(User? user, {bool shouldPresence: true}) async {
  //  if (user != null) {
  //    UserProfilePage? profile = await fetchProfileForFirebaseUser(user.uid);
  //    if (profile != null) {
  //      setPropertiesForLoggedInUser(user, profile);
  //    }
  //  }
  //  if (shouldPresence) notifyListeners();
  //}

/*
  setPropertiesForNullUser() {
    this.firebaseUser = null;
    this.isUserLoggedIn = false;
    this.userRole = 0;
    this._currentUserProfile = null;

    // Remove the notifyListeners here once you start using firebase and updateUser function
    notifyListeners();
  }

  setPropertiesForLoggedInUser(User user, UserProfilePage profile) {
    this.firebaseUser = user;
    this.isUserLoggedIn = true;
    this.userRole = profile.userRole;
    this._currentUserProfile = profile;

    // Remove the notifyListeners here once you start using firebase and updateUser function
    notifyListeners();
  }

  Future<UserProfilePage> fetchProfileForFirebaseUser(String fbuid) async {
    // Make an OAuth call to confirm the credentials and register user on server
    // OAuth call should also provide access and refresh tokens
    // The tokens get stored as shared instance during app runtime

    // bool isLoggedIn = await oAuthLogin(fbuid);
    // if (!isLoggedIn) return null;

    // If user is successfully logged in, fetch their profile from server
    // Make a user data model (here userProfile) and store user details

    // UserProfile profile = await fetchMyUserProfile();
    // return profile;

    return null;
  }
 */
  // External callers can use this to access logged in user's profile
  UserProfilePage getUser() {
    return this._currentUserProfile;
  }

  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
  */
}
