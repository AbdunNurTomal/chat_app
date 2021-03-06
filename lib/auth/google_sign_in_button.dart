//import 'package:chat_app/pages/users/user_profile_page.dart';
import 'package:chat_app/auth/user_profile.dart';
import 'package:chat_app/provider/login_signup_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_auth_service.dart';
import 'user_profile.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  FirebaseAuthService _authentication = FirebaseAuthService();

  bool _isGoogleSigningIn = false;
  String errorMsg = '';
  final FirebaseAuth auth = FirebaseAuth.instance;

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

                LoginSignupProvider loginSignupProvider =
                    Provider.of<LoginSignupProvider>(context, listen: false);

                _authentication.signInWithGoogle(
                    loginSignupProvider: loginSignupProvider, context: context);

                setState(() {
                  _isGoogleSigningIn = false;
                });
              },
              child: const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Image(
                  image: AssetImage("images/google_logo.png"),
                  height: 35.0,
                ),
              )),
    );
  }
}
