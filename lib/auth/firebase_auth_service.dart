import '/models/user.dart';
import '/pages/admin/admin_home_page.dart';
import '/pages/customer/customer_home_page.dart';
import '/pages/manager/manager_home_page.dart';
import '/pages/message/message_home_page.dart';
import '/pages/supervisor/supervisor_home_page.dart';
import '/provider/login_signup_provider.dart';
import '/utils/global_methods.dart';
import '/utils/responsive_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'login_page.dart';

class FirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  //static User? get currentUser => _auth.currentUser;

  Future<void> login(Users users, LoginSignupProvider loginSignupProvider,
      BuildContext context) async {
    UserCredential result;

    try {
      result = await _auth.signInWithEmailAndPassword(
          email: users.userEmail, password: users.userPassword);
    } on FirebaseException catch (error) {
      GlobalMethod.showErrorDialog(error: error.message!, ctx: context);
    }

    // check email verification
    try {
      User? user = _auth.currentUser;
      if (!user!.emailVerified) {
        _auth.signOut();
        GlobalMethod.showErrorDialog(
            error: 'Email ID not Verified', ctx: context);
      } else {
        print('Logged In: $user');
        loginSignupProvider.setUser(user);
        await getUserDetails(loginSignupProvider);
        print('done');

        // admin or user navigation
        if (Responsive.isDesktop(context) || Responsive.isTablet(context)) {
          Navigator.pushReplacementNamed(context, MessageHomePage.routeName);
        } else {
          switch (loginSignupProvider.userDetails.userRole) {
            case 'admin':
              Navigator.pushReplacementNamed(context, AdminHomePage.routeName);
              //Navigator.push(context, MaterialPageRoute(builder: (_) => AdminHomePage()));
              break;
            case 'manager':
              Navigator.pushReplacementNamed(
                  context, ManagerHomePage.routeName);
              //Navigator.push(context, MaterialPageRoute(builder: (_) => ManagerHomePage()));
              break;
            case 'supervisor':
              Navigator.pushReplacementNamed(
                  context, SupervisorHomePage.routeName);
              //Navigator.push(context,MaterialPageRoute(builder: (_) => SupervisorHomePage()));
              break;
            default:
              Navigator.pushReplacementNamed(
                  context, CustomerHomePage.routeName);
              //Navigator.push(context, MaterialPageRoute(builder: (_) => CustomerHomePage()));
              break;
          }
        }

        //if (loginSignupProvider.userDetails.userRole == 'admin') {
        //  Navigator.push(
        //      context, MaterialPageRoute(builder: (_) => AdminHomeScreen()));
        //} else {
        //  Navigator.push(
        //      context,
        //      MaterialPageRoute(
        //          builder: (_) => NavigationBar(
        //                selectedIndex: 0,
        //              )));
        //}
      }
    } on FirebaseException catch (error) {
      GlobalMethod.showErrorDialog(error: error.message!, ctx: context);
    }
  }

  // to get user details
  Future<void> getUserDetails(LoginSignupProvider loginSignupProvider) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(loginSignupProvider.user.uid)
        .get()
        .then((value) {
      print(value);
      //loginSignupProvider.setUserDetails(Users.fromMap(value.data()));
    });
  }

  // initialize current user
  Future<void> initializeCurrentUser(
      LoginSignupProvider loginSignupProvider) async {
    User? user = _auth.currentUser;

    if (user != null) {
      loginSignupProvider.setUser(user);
      await getUserDetails(loginSignupProvider);
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
      await _auth.signOut();
      print('Log out');
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
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
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await _auth.signInWithPopup(authProvider);
        user = userCredential.user;
      } catch (e) {
        print(e);
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
          final UserCredential userCredential =
              await _auth.signInWithCredential(credential);
          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                  content:
                      'The account already exists with a different credential.'),
            );
          } else if (e.code == 'invalid-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                  content:
                      'Error occurred while accessing credentials. Try again.'),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
                content: 'Error occurred using Google Sign-In. Try again.'),
          );
        }
      }
    }
    return user;
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }
}
