import 'pages/admin/admin_home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth/auth_dialog.dart';
import 'auth/firebase_auth_service.dart';
import 'pages/customer/customer_home_page.dart';
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
    LoginSignupProvider loginSignupProvider =
        Provider.of<LoginSignupProvider>(context);
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
        GestureDetector(
          onTap: () {
            // check user null
            if (loginSignupProvider.user == null) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => AuthDialog()));
            } else if (loginSignupProvider.userDetails == null) {
              print('wait');
            } else if (loginSignupProvider.userDetails.userRole == 'admin') {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => AdminHomePage()));
            } else {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => CustomerHomePage()));
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              "Explore",
              style: TextStyle(
                fontSize: 20,
                color: Color.fromRGBO(255, 63, 111, 1),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        const Center(
          child: CircularProgressIndicator(),
        ),
      ],
    ));
  }
}
