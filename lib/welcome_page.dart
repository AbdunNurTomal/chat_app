import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'auth/firebase_auth_service.dart';
import 'auth/wait_room.dart';
import 'pages/admin/admin_home_page.dart';
import 'pages/customer/customer_home_page.dart';
import 'pages/manager/manager_home_page.dart';
import 'pages/message/message_home_page.dart';
import 'pages/supervisor/supervisor_home_page.dart';
import 'provider/login_signup_provider.dart';
import 'utils/constants.dart';
import 'utils/custom_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'component/side_menu.dart';
import 'utils/responsive_screen.dart';

class WelcomePage extends StatefulWidget {
  //const WelcomePage({Key? key}) : super(key: key);
  static const String routeName = "\welcome_page";

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseAuthService _authentication = FirebaseAuthService();
  bool isLoggedIn = false;
  String? _userRole;

  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      print('Init User role = ');

      Future.delayed(Duration(seconds: 1), () async {
        print("delay 3 seconds");
        LoginSignupProvider loginSignupProvider =
            Provider.of<LoginSignupProvider>(context, listen: false);

        await _authentication.initializeCurrentUser(
            context, loginSignupProvider);

        print("User details - ");

        _userRole = loginSignupProvider.userDetails.userRole;
        print(_userRole);
        if (loginSignupProvider.userDetails.userRole == null) {
          Navigator.pushReplacementNamed(context, WaitingRoom.routeName);
        }
      });
      setState(() {
        isLoggedIn = true;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Welcome'),
        ),
        body: _userRoleOperation(_userRole));
  }

  Widget _userRoleOperation(_userRole) {
    print('User role = ');
    print(_userRole);
    if (_userRole != null) {
      switch (_userRole) {
        case 'admin':
          return AdminHomePage();
        case 'manager':
          return ManagerHomePage();
        case 'supervisor':
          return SupervisorHomePage();
        default:
          return CustomerHomePage();
      }
    } else {
      return WaitingRoom();
    }
  }
}
