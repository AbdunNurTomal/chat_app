import 'package:provider/provider.dart';

import 'auth/firebase_auth_service.dart';
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
  //User? _user;
  //FirebaseAuthService _authentication = FirebaseAuthService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() async {
    super.initState();
    //LoginSignupProvider loginSignupProvider =
    //    Provider.of<LoginSignupProvider>(context);

    //Future.delayed(Duration(seconds: 3), () async {
    //  print("delay 3 seconds");

    //await _authentication.initializeCurrentUser(context, loginSignupProvider);
    //print(loginSignupProvider.user);
    //print("User details - ");
    //print(loginSignupProvider.userDetails.userRole);
    //await _authentication.userRoleOperation(loginSignupProvider);
    //switch (loginSignupProvider.userDetails.userRole) {
    //  case 'admin':
    //    //Navigator.pushReplacementNamed(context, AdminHomePage.routeName);
    //    Navigator.push(
    //        context, MaterialPageRoute(builder: (_) => AdminHomePage()));
    //    break;
    //  case 'manager':
    //    //Navigator.pushReplacementNamed(context, ManagerHomePage.routeName);
    //    Navigator.push(
    //        context, MaterialPageRoute(builder: (_) => ManagerHomePage()));
    //    break;
    //  case 'supervisor':
    //    //Navigator.pushReplacementNamed(context, SupervisorHomePage.routeName);
    //    Navigator.push(
    //        context, MaterialPageRoute(builder: (_) => SupervisorHomePage()));
    //    break;
    //  default:
    //    //Navigator.pushReplacementNamed(context, CustomerHomePage.routeName);
    //    Navigator.push(
    //        context, MaterialPageRoute(builder: (_) => CustomerHomePage()));
    //    break;
    //}
    //});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 250),
          child: SideMenu(),
        ),
        body: Text("Welcome")
        /*
        Container(
          padding: EdgeInsets.only(top: kIsWeb ? Constants.kDefaultPadding : 0),
          color: CustomColors.kBgDarkColor,
          child: SafeArea(
            right: false,
            child: Column(
              children: [
                // This is our bar
                Row(
                  children: [
                    // Once user click the menu icon the menu shows like drawer
                    // Also we want to hide this menu icon on desktop
                    if (!Responsive.isDesktop(context))
                      IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () {
                          _scaffoldKey.currentState!.openDrawer();
                        },
                      ),
                    if (!Responsive.isDesktop(context)) SizedBox(width: 5),
                    Expanded(
                      child: Text('Welcome To Team'),
                    ),
                  ],
                ),
                SizedBox(height: Constants.kDefaultPadding),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Constants.kDefaultPadding),
                  child: Text('Hello Universe'),
                ),
              ],
            ),
          ),
        )
        */
        );
  }
}
