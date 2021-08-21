import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth/auth_dialog.dart';
import 'auth/firebase_auth_service.dart';
import 'auth/user_profile.dart';
import 'pages/admin/admin_home_page.dart';
import 'pages/customer/customer_home_page.dart';
import 'pages/manager/manager_home_page.dart';
import 'pages/message/message_home_page.dart';
import 'pages/supervisor/supervisor_home_page.dart';
import 'provider/login_signup_provider.dart';
import 'utils/responsive_screen.dart';

class LauncherPage extends StatefulWidget {
  static const String routeName = "\launcher";

  @override
  _LauncherPageState createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  FirebaseAuthService _firebaseAuthService = new FirebaseAuthService();
  User? _user;

  @override
  void initState() {
    LoginSignupProvider loginSignupProvider =
        Provider.of<LoginSignupProvider>(context, listen: false);
    Future.delayed(Duration(seconds: 3), () async {
      // initialize current user
      _user =
          await _firebaseAuthService.initializeCurrentUser(loginSignupProvider);

      if (_user == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => AuthDialog()));
      } else if (loginSignupProvider.userDetails == null) {
        print('wait');
        //print(_user);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => UserProfile(user: _user!),
          ),
        );
      } else if (loginSignupProvider.userDetails!.userRole != '') {
        String? userRole = loginSignupProvider.userDetails!.userRole;
        // admin or user navigation
        if (Responsive.isDesktop(context) || Responsive.isTablet(context)) {
          switch (userRole) {
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
        } else {
          Navigator.pushReplacementNamed(context, MessageHomePage.routeName);
        }
      } else {
        Navigator.pushReplacementNamed(context, CustomerHomePage.routeName);
      }
    });
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
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
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
