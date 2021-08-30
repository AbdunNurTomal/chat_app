import 'package:chat_app/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/models/user.dart';
import '/pages/admin/admin_home_page.dart';
import '/pages/customer/customer_home_page.dart';
import '/pages/manager/manager_home_page.dart';
import '/pages/supervisor/supervisor_home_page.dart';
import '/provider/login_signup_provider.dart';
import '/utils/global_methods.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'auth_dialog.dart';

class FirebaseAuthService {
  //final FirebaseAuth _firebaseAuth;
  //FirebaseAuthService(this._firebaseAuth);

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Users user = Users();
  User? get currentUser => _firebaseAuth.currentUser;

  static final userRef = FirebaseFirestore.instance.collection("users");

  Stream<User?> get authState => _firebaseAuth.authStateChanges();

  Future<void> login(Users users, LoginSignupProvider loginSignupProvider,
      BuildContext context) async {
    String email = users.userEmail.toString().trim();
    String password = users.userPassword.toString().trim();

    try {
      print("$email password $password");
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseException catch (error) {
      GlobalMethod.showErrorDialog(error: error.message!, ctx: context);
    }

    try {
      //User? user = _firebaseAuth.currentUser;
      print('login>> user email veriried :');
      print(_firebaseAuth.currentUser!.emailVerified);
      if (!_firebaseAuth.currentUser!.emailVerified) {
        _firebaseAuth.signOut();
        GlobalMethod.showErrorDialog(
            error: 'Email ID not Verified', ctx: context);
        await _firebaseAuth.currentUser!.sendEmailVerification();
      } else {
        print('login>>auth dialog login user role');
        Navigator.pushReplacementNamed(context, WelcomePage.routeName);
      }
    } on FirebaseException catch (error) {
      GlobalMethod.showErrorDialog(error: error.message!, ctx: context);
    }

    //try {
    //  User? user = _firebaseAuth.currentUser;
    //  if (!user!.emailVerified) {
    //    _firebaseAuth.signOut();
    //    GlobalMethod.showErrorDialog(
    //        error: 'Email ID not Verified', ctx: context);
    //    await user.sendEmailVerification();
    //  } else {
    //    print('Logged In: $user');
    //    loginSignupProvider.setUser(user);
    //    await getUserDetails(context, loginSignupProvider);
    //    print('done');
    //    //print(loginSignupProvider.user);
    //    //print("User details - ");
    //    //print(loginSignupProvider.userDetails.userRole);
    //
    //    //if (loginSignupProvider.userDetails.userRole == 'admin') {
    //    //  Navigator.push(
    //    //      context, MaterialPageRoute(builder: (_) => AdminHomeScreen()));
    //    //} else {
    //    //  Navigator.push(
    //    //      context,
    //    //      MaterialPageRoute(
    //    //          builder: (_) => NavigationBar(
    //    //                selectedIndex: 0,
    //    //              )));
    //    //}
    //  }
    //} on FirebaseException catch (error) {
    //  GlobalMethod.showErrorDialog(error: error.message!, ctx: context);
    //}
  }

  // to get user details
  Future<void> getUserDetails(
      BuildContext context, LoginSignupProvider loginSignupProvider) async {
    print('Firebase>> getUserDetails :');
    print(loginSignupProvider.user.email);
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(loginSignupProvider.user.uid)
          .get()
          .then((value) => {
                print('data -'),
                print(value.data().toString()),
                if (value.data() == null)
                  {
                    print('if not set user profile'),
                    GlobalMethod.needToSetUserProfile = true,
                  }
                else
                  {
                    user = Users.fromMap(value.data()!),
                    print('else set user profile :'),
                    print(user.displayName),
                    print('Firebase>> user role :'),
                    print(user.userRole),
                    loginSignupProvider.setUserDetails(user),
                    print('Firebase>> user role from userDetails :'),
                    print(loginSignupProvider.userDetails.userRole!),
                    GlobalMethod.needToSetUserRole =
                        loginSignupProvider.userDetails.userRole!,
                  }
              });
    } on FirebaseException catch (error) {
      GlobalMethod.showErrorDialog(error: error.message!, ctx: context);
    }
  }

  // initialize current user
  Future<void> initializeCurrentUser(
      BuildContext context, LoginSignupProvider loginSignupProvider) async {
    print("Firebase>> initialize Current User");
    if (_firebaseAuth.currentUser != null) {
      print("if");
      loginSignupProvider.setUser(_firebaseAuth.currentUser);
      await getUserDetails(context, loginSignupProvider);
    }
  }

  void userRoleOperation(
      BuildContext context, LoginSignupProvider loginSignupProvider) {
    switch (loginSignupProvider.userDetails.userRole) {
      case 'admin':
        Navigator.pushReplacementNamed(context, AdminHomePage.routeName);
        break;
      case 'manager':
        Navigator.pushReplacementNamed(context, ManagerHomePage.routeName);
        break;
      case 'supervisor':
        Navigator.pushReplacementNamed(context, SupervisorHomePage.routeName);
        break;
      default:
        Navigator.pushReplacementNamed(context, CustomerHomePage.routeName);
        break;
    }
  }

  // signout
  Future<void> signOut(
      LoginSignupProvider loginSignupProvider, BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await _firebaseAuth.signOut();
      print('Log out');
      Navigator.pushReplacementNamed(context, AuthDialog.routeName);
    } on FirebaseException catch (error) {
      GlobalMethod.showErrorDialog(error: error.message!, ctx: context);
    }
  }

/*
  static Future<User?> loginUser(
      {required String email, required String pass}) async {
    User? user;
    final UserCredential userCredential =
        await _auth.signInWithEmailAndPassword(email: email, password: pass);
    user = userCredential.user;
    return user;
  }

  static Future<User?> registerUser(String email, String pass) async {
    final result = await _auth.createUserWithEmailAndPassword(
        email: email, password: pass);
    return result.user;
  }


  static Future<FirebaseApp> initializeFirebase(
      {required BuildContext context}) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    //User? user = _auth.currentUser;
    if (_auth.currentUser != null) {
      //Navigator.of(context).pushReplacement(
      //  MaterialPageRoute(
      //    builder: (context) => UserInfoScreen(
      //      user: user,
      //    ),
      //  ),
      //);
      //Navigator.pushReplacementNamed(context, ChatRoomPage.routeName);
      Navigator.pushReplacementNamed(context, HomePage.routeName);
    }

    return firebaseApp;
  }
*/
  Future<void> signInWithGoogle(
      {required LoginSignupProvider loginSignupProvider,
      required BuildContext context}) async {
    UserCredential userCredential;
    print('Firebase>> signInWithGoogle :');

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        userCredential = await _firebaseAuth.signInWithPopup(authProvider);
        print('for web');
      } on FirebaseException catch (error) {
        GlobalMethod.showErrorDialog(error: error.message!, ctx: context);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          userCredential = await _firebaseAuth.signInWithCredential(credential);
          print('for android');
        } on FirebaseException catch (error) {
          if (error.code == 'account-exists-with-different-credential') {
            GlobalMethod.showErrorDialog(
                error:
                    'The account already exists with a different credential.',
                ctx: context);
          } else if (error.code == 'invalid-credential') {
            GlobalMethod.showErrorDialog(
                error: 'Error occurred while accessing credentials. Try again.',
                ctx: context);
          }
        } catch (error) {
          GlobalMethod.showErrorDialog(
              error: 'Error occurred using Google Sign-In. Try again.',
              ctx: context);
          //ScaffoldMessenger.of(context).showSnackBar(
          //  customSnackBar(
          //      content: 'Error occurred using Google Sign-In. Try again.'),
          //);
        }
      }
    }
    //return user;
  }
}
