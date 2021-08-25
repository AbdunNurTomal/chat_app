import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/models/user.dart';
import '/pages/admin/admin_home_page.dart';
import '/pages/customer/customer_home_page.dart';
import '/pages/manager/manager_home_page.dart';
import '/pages/message/message_home_page.dart';
import '/pages/supervisor/supervisor_home_page.dart';
import '/provider/login_signup_provider.dart';
import '/utils/global_methods.dart';
import '/utils/responsive_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'auth_dialog.dart';
import 'login_page.dart';
import 'user_profile.dart';

class FirebaseAuthService {
  //final FirebaseAuth _firebaseAuth;
  //FirebaseAuthService(this._firebaseAuth);

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Users user = Users();
  final userRef = FirebaseFirestore.instance.collection("users");

  UserCredential? result;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> login(Users users, LoginSignupProvider loginSignupProvider,
      BuildContext context) async {
    String email = users.userEmail.toString().trim();
    String password = users.userPassword.toString().trim();

    try {
      print("$email password $password");
      result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      //print(result);
    } on FirebaseException catch (error) {
      GlobalMethod.showErrorDialog(error: error.message!, ctx: context);
    }

    // check email verification
    try {
      if (result != null) {
        User? user = _firebaseAuth.currentUser;
        if (!user!.emailVerified) {
          _firebaseAuth.signOut();
          GlobalMethod.showErrorDialog(
              error: 'Email ID not Verified', ctx: context);
          await result!.user!.sendEmailVerification();
        } else {
          print('Logged In: $user');
          loginSignupProvider.setUser(user);
          await getUserDetails(context, loginSignupProvider);
          print('done');

          // admin or user navigation
          //if (Responsive.isDesktop(context) || Responsive.isTablet(context)) {
          //  switch (loginSignupProvider.userDetails.first) {
          //    case 'admin':
          //      Navigator.pushReplacementNamed(
          //          context, AdminHomePage.routeName);
          //      //Navigator.push(context, MaterialPageRoute(builder: (_) => AdminHomePage()));
          //      break;
          //    case 'manager':
          //      Navigator.pushReplacementNamed(
          //          context, ManagerHomePage.routeName);
          //      //Navigator.push(context, MaterialPageRoute(builder: (_) => ManagerHomePage()));
          //      break;
          //    case 'supervisor':
          //      Navigator.pushReplacementNamed(
          //          context, SupervisorHomePage.routeName);
          //      //Navigator.push(context,MaterialPageRoute(builder: (_) => SupervisorHomePage()));
          //      break;
          //    default:
          //      Navigator.pushReplacementNamed(
          //          context, CustomerHomePage.routeName);
          //      //Navigator.push(context, MaterialPageRoute(builder: (_) => CustomerHomePage()));
          //      break;
          //  }
          //} else {
          //  Navigator.pushReplacementNamed(context, MessageHomePage.routeName);
          //}

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
      }
    } on FirebaseException catch (error) {
      GlobalMethod.showErrorDialog(error: error.message!, ctx: context);
    }
  }

  // to get user details
  Future<void> getUserDetails(
      BuildContext context, LoginSignupProvider loginSignupProvider) async {
    print(loginSignupProvider.user.email);
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(loginSignupProvider.user.uid)
          .get()
          .then((value) => {
                print(value.data().toString()),
                if (value.data() == null)
                  {
                    Navigator.pushReplacementNamed(
                        context, UserProfile.routeName,
                        arguments: [loginSignupProvider.user])
                  }
                else
                  {
                    user = Users.fromMap(value.data()!),
                    print(user.displayName),
                    loginSignupProvider.setUserDetails(user),
                  }
              });
    } on FirebaseException catch (error) {
      GlobalMethod.showErrorDialog(error: error.message!, ctx: context);
      //print(error.message!);
    }
  }

  // initialize current user
  Future<void> initializeCurrentUser(
      BuildContext context, LoginSignupProvider loginSignupProvider) async {
    //print(_firebaseAuth.currentUser);
    if (_firebaseAuth.currentUser != null) {
      //print("initialize Current User if");
      loginSignupProvider.setUser(_firebaseAuth.currentUser);
      await getUserDetails(context, loginSignupProvider);
    } else {
      //print("initializ Current User else");
      Navigator.pushReplacementNamed(context, AuthDialog.routeName);
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
  Future<void> signInWithGoogle(
      {required LoginSignupProvider loginSignupProvider,
      required BuildContext context}) async {
    final UserCredential userCredential;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        userCredential = await _firebaseAuth.signInWithPopup(authProvider);
        if (userCredential.user != null) {
          loginSignupProvider.setUser(userCredential.user!);
          //Navigator.pushReplacement(
          //    context, MaterialPageRoute(builder: (context) => HomePage()));
        }
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
          if (userCredential.user != null) {
            loginSignupProvider.setUser(userCredential.user!);
            //Navigator.pushReplacement(
            //    context, MaterialPageRoute(builder: (context) => HomePage()));
          }
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
