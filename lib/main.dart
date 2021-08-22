import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'auth/wait_room.dart';
import 'pages/admin/admin_home_page.dart';
import 'pages/customer/customer_home_page.dart';
import 'pages/manager/manager_home_page.dart';
import 'pages/supervisor/supervisor_home_page.dart';
import 'provider/login_signup_provider.dart';
import 'launcher_page.dart';
import 'auth/auth_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => LoginSignupProvider()),
      //ChangeNotifierProvider(create: (_) => ProductDetail()),
    ], child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  //const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PQC',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: LauncherPage(),
        routes: {
          LauncherPage.routeName: (context) => LauncherPage(),
          WaitingRoom.routeName: (context) => WaitingRoom(),
          AuthDialog.routeName: (context) => AuthDialog(),
          AdminHomePage.routeName: (context) => AdminHomePage(),
          CustomerHomePage.routeName: (context) => CustomerHomePage(),
          ManagerHomePage.routeName: (context) => ManagerHomePage(),
          SupervisorHomePage.routeName: (context) => SupervisorHomePage(),
          //ChatRoomPage.routeName: (context) => ChatRoomPage(),
          //UserProfilePage.routeName: (context) => UserProfilePage(),
        });
  }
}
