import 'package:chat_app/utils/global_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'auth/firebase_auth_service.dart';
import 'auth/user_profile.dart';
import 'auth/wait_room.dart';
import 'pages/admin/admin_home_page.dart';
import 'pages/customer/customer_home_page.dart';
import 'pages/manager/manager_home_page.dart';
import 'pages/supervisor/supervisor_home_page.dart';
import 'provider/login_signup_provider.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  //const WelcomePage({Key? key}) : super(key: key);
  static const String routeName = "\welcome_page";

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseAuthService _authentication = FirebaseAuthService();
  String _userRole = '';

  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      print('Welcome Init');

      Future.delayed(Duration(seconds: 2), () async {
        print("Welcome>> delay 3 seconds");
        LoginSignupProvider loginSignupProvider =
            Provider.of<LoginSignupProvider>(context, listen: false);

        print("Welcome>> initialize current user :");
        await _authentication.initializeCurrentUser(
            context, loginSignupProvider);

        if (GlobalMethod.needToSetUserProfile) {
          print("Welcome>> need To Set User Profile :");
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => UserProfile()));
        }
        if (GlobalMethod.needToSetUserRole != '') {
          print("Welcome>> check User role :");
          setState(() {
            _userRole = loginSignupProvider.userDetails.userRole!;
          });
          print("Welcome>> user role - $_userRole");
        }
      });

      setState(() {
        GlobalMethod.isLoggedIn = true;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: AppBar(
        //  title: Text('Welcome'),
        //),
        body: _userRoleOperation(_userRole));
  }

  Widget _userRoleOperation(_userRole) {
    print('Welcome>> user role = $_userRole');
    switch (_userRole) {
      case 'admin':
        return AdminHomePage();
      case 'manager':
        return ManagerHomePage();
      case 'supervisor':
        return SupervisorHomePage();
      case 'teamleader':
        return TeamLeaderPage();
      case 'customer':
        return CustomerHomePage();
      default:
        return WaitingRoom();
    }
  }
}
