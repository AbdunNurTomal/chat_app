import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth/auth_dialog.dart';
import 'welcome_page.dart';

class LauncherPage extends StatelessWidget {
  //const ({ Key? key }) : super(key: key);
  static const String routeName = "\launcher";
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
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
        final user = snapshot.data;
        if (user != null &&
            FirebaseAuth.instance.currentUser!.emailVerified == true) {
          print("user is logged in");
          //print(user);
          //Navigator.of(context)
          //    .push(MaterialPageRoute(builder: (_) => WelcomePage()));
          return Container();
        } else {
          print("user is not logged in");
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => AuthDialog()));
          return Container();
        }
      },
    );
/*
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          print(snapshot);
          if (snapshot.hasData) {
            User? user = snapshot.data;
            if (user == null) {
              //return WelcomePage(firestore: firestore,
              //    uuid: snapshot.data.uid);
              return AuthDialog();
            }
            print(user);
            return WelcomePage();
          } else {
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

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
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
            case ConnectionState.active:
              Text('waiting');
              User? user = snapshot.data;
              if (user == null) {
                //return WelcomePage(firestore: firestore,
                //    uuid: snapshot.data.uid);
                return AuthDialog();
              }
              print(user);
              return WelcomePage();
            case ConnectionState.done:
              return Text('done');
            case ConnectionState.none:
              return Text('none');
            default:
              return Text('default');
          }
          
        });
*/
  }
}
