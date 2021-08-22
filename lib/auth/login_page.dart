import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../auth/google_sign_in_button.dart';
import '../../utils/custom_color.dart';
import '../../welcome_page.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = "\login";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController(text: '');
  final TextEditingController passwordController =
      TextEditingController(text: '');

  bool isLogin = true;
  String errorMsg = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: CustomColors.primaryColor,
        body: Form(
            key: _loginFormKey,
            child: Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Sign in to Chat Room and continue',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                          color: Colors.white, fontSize: 28),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Enter your email and password below to continue to the Team and let the begin!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                          color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: CustomColors.secondaryColor,
                          border: Border.all(color: Colors.blue)),
                      child: TextFormField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            labelText: 'Email Address',
                            labelStyle: TextStyle(color: Colors.white),
                            icon:
                                Icon(Icons.account_circle, color: Colors.white),
                            border: InputBorder.none),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please provide a valid email address.';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: CustomColors.secondaryColor,
                          border: Border.all(color: Colors.blue)),
                      child: TextFormField(
                        controller: passwordController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.white),
                            icon: Icon(Icons.lock, color: Colors.white),
                            border: InputBorder.none),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please provide a valid password.';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              isLogin = false;
                              _loginUser();
                            },
                            child: const Text('Forget Password'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    MaterialButton(
                      elevation: 0,
                      minWidth: double.maxFinite,
                      height: 50,
                      onPressed: () {
                        isLogin = true;
                        _loginUser();
                      },
                      color: CustomColors.logoGreen,
                      child: const Text('Login',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      textColor: Colors.white,
                    ),
                    const SizedBox(height: 20),
                    FutureBuilder(
                      //future: FirebaseAuthService.initializeFirebase(context: context),
                      future: Firebase.initializeApp(),
                      builder: (context, snapshot) {
                        //print(snapshot.connectionState);
                        if (snapshot.hasError) {
                          return const Text('Error initializing Firebase');
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          return GoogleSignInButton();
                        }
                        return const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            CustomColors.firebaseOrange,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Not register yet? ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13)),
                          TextButton(
                            onPressed: () {
                              isLogin = false;
                              _loginUser();
                            },
                            child: const Text('Register'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(errorMsg,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 20)),
                    ),
                    const SizedBox(height: 5),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: _buildFooterLogo())
                  ],
                ),
              ),
            )));
  }

  void _loginUser() async {
    final isValid = _loginFormKey.currentState!.validate();
    if (isValid) {
      final email = emailController.text;
      final password = passwordController.text;
      User? user;
      try {
        if (isLogin) {
          //user = await FirebaseAuthService.loginUser(email: email, pass: password);
        } else {
          //user = await FirebaseAuthService.registerUser(context: context, email, password);
        }
        if (user != null) {
          Navigator.pushReplacementNamed(context, WelcomePage.routeName);
          //Navigator.pushReplacementNamed(context, HomePage.routeName);
          //Navigator.of(context).pushReplacement(
          //  MaterialPageRoute(
          //    builder: (context) => UserProfilePage(
          //      user: user,
          //    ),
          //  ),
          //);
        }
      } on FirebaseException catch (error) {
        setState(() {
          errorMsg = error.message!;
        });
        rethrow;
      }
    }
  }

  _buildFooterLogo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'images/pqc.png',
          height: 40,
        ),
        Text('Team & Co. Ltd',
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  //_ForgetPasswordScreen() {}
}
