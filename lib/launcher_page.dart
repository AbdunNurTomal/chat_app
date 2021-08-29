import 'package:chat_app/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth/auth_dialog.dart';

class LauncherPage extends StatefulWidget {
  //const LauncherPage({Key? key}) : super(key: key);
  static const String routeName = "\launcher";

  @override
  _LauncherPageState createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            //Future.delayed(Duration(seconds: 2), () {
            //  print("delay 2 seconds");
            //});
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                print('Launcher>> waiting');
                return _circularSpin();
              case ConnectionState.active:
                print('Launcher>> active');
                final user = snapshot.data;
                if (user != null) {
                  if (FirebaseAuth.instance.currentUser!.emailVerified ==
                      false) {
                    print('Launcher>> email not verified');
                    FirebaseAuth.instance.signOut();
                    //GlobalMethod.showErrorDialog(error: 'Email ID not Verified', ctx: context);
                    //user.sendEmailVerification();
                    return Text('Launcher>> send email verification');
                  } else {
                    print('Launcher>> email verified');
                    return WelcomePage();
                    //return Text('Email verified');
                  }
                } else {
                  print('Launcher>> login page');
                  return AuthDialog();
                }
              case ConnectionState.done:
                print('Launcher>> done');
                return Text('done');
              case ConnectionState.none:
                print('Launcher>> none');
                return Text('none');
              default:
                print('Launcher>> default');
                return Text('default');
            }
          }
        });
  }

  Widget _circularSpin() {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'images/pqc.png',
          height: 250,
        ),
        const SizedBox(height: 20),
        const Text(
          'Welcome',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontSize: 28),
        ),
        const SizedBox(height: 20),
        const Text(
          'Team Application',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        //const SizedBox(height: 30),
        //GestureDetector(
        //  onTap: () {
        //    // check user null
        //    await userRoleOperation(context, loginSignupProvider);
        //
        //  },
        //  child: Container(
        //    padding: const EdgeInsets.symmetric(
        //        horizontal: 80, vertical: 15),
        //    decoration: BoxDecoration(
        //      color: Colors.white,
        //      borderRadius: BorderRadius.circular(30),
        //    ),
        //    child: const Text(
        //      "Explore",
        //      style: TextStyle(
        //        fontSize: 20,
        //        color: Color.fromRGBO(255, 63, 111, 1),
        //      ),
        //    ),
        //  ),
        //),
        const SizedBox(height: 30),
        const Center(
          child: CircularProgressIndicator(),
        ),
      ],
    ));
  }
}
