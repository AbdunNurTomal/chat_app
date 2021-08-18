import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth/firebase_auth_service.dart';
import 'provider/login_signup_provider.dart';

class LauncherPage extends StatefulWidget {
  static const String routeName = "\launcher";

  @override
  _LauncherPageState createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  FirebaseAuthService _firebaseAuthService = new FirebaseAuthService();

  @override
  void initState() {
    LoginSignupProvider loginSignupProvider =
        Provider.of<LoginSignupProvider>(context, listen: false);
    // initialize current user
    _firebaseAuthService.initializeCurrentUser(loginSignupProvider);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'images/launcher_icon.png',
          height: 250,
        ),
        const SizedBox(height: 20),
        const Text(
          'Welcome to --- !',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 28),
        ),
        const SizedBox(height: 20),
        const Text(
          'Team Chat Application',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 30),
        const Center(
          child: CircularProgressIndicator(),
        ),
      ],
    ));
  }
}
