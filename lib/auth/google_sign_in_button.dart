//import 'package:chat_app/pages/users/user_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../welcome_page.dart';
import 'firebase_auth_service.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isGoogleSigningIn = false;
  String errorMsg = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isGoogleSigningIn
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
          : OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40))),
              ),
              onPressed: () async {
                setState(() {
                  _isGoogleSigningIn = true;
                });

                User? user = await FirebaseAuthService.signInWithGoogle(
                    context: context);

                setState(() {
                  _isGoogleSigningIn = false;
                });

                if (user != null) {
                  Navigator.pushReplacementNamed(
                      context, WelcomePage.routeName);
                  //Navigator.of(context).pushReplacement(
                  //  MaterialPageRoute(
                  //    builder: (context) => UserProfilePage(
                  //      user: user,
                  //    ),
                  //  ),
                  //);
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Image(
                  image: AssetImage("images/google_logo.png"),
                  height: 35.0,
                ),
              )),
    );
  }
}
