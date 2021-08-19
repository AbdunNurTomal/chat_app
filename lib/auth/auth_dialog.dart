import 'package:chat_app/models/user.dart';
import 'package:chat_app/utils/global_methods.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../utils/custom_color.dart';
import 'firebase_auth_service.dart';
import 'google_sign_in_button.dart';
import 'forget_password.dart';
import '../provider/login_signup_provider.dart';
import 'signup.dart';

class AuthDialog extends StatefulWidget {
  //const AuthDialog({Key? key}) : super(key: key);
  static const String routeName = "\auth_dialog";

  @override
  _AuthDialogState createState() => _AuthDialogState();
}

class _AuthDialogState extends State<AuthDialog> {
  Users _users = new Users();
  FirebaseAuthService _authentication = new FirebaseAuthService();
  final _loginFormKey = GlobalKey<FormState>();
  bool showPassword = true;

  late FocusNode textFocusNodeEmail;
  bool _isEditingEmail = false;

  late FocusNode textFocusNodePassword;
  bool _isEditingPassword = false;

  bool _isRegistering = false;

  //String? loginStatus;
  Color loginStringColor = Colors.green;

  @override
  void dispose() {
    GlobalMethod.emailController.dispose();
    GlobalMethod.passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    LoginSignupProvider loginSignupProvider =
        Provider.of<LoginSignupProvider>(context, listen: false);
    // initialize current user
    _authentication.initializeCurrentUser(loginSignupProvider);
    GlobalMethod.emailController = TextEditingController();
    GlobalMethod.emailController.text = '';
    GlobalMethod.passwordController = TextEditingController();
    GlobalMethod.passwordController.text = '';
    textFocusNodeEmail = FocusNode();
    textFocusNodePassword = FocusNode();
    super.initState();
  }

  void _loginUser() {
    final isValid = _loginFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _loginFormKey.currentState!.save();

    LoginSignupProvider loginSignupProvider =
        Provider.of<LoginSignupProvider>(context, listen: false);

    _authentication.login(_users, loginSignupProvider, context);
  }

/*
  void loginUser() {
    final isValid = _loginFormKey.currentState!.validate();
    if (isValid) {
      final email = GlobalMethod.emailController.text;
      final password = GlobalMethod.passwordController.text;

      try {
        //User? user;
        if (isUserLoggedIn) {
          firebaseUser =
              await FirebaseAuthService.loginUser(email: email, pass: password);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignUp(),
            ),
          );
          //uid = await FirebaseAuthService.registerUser(email,password);
        }
        if (firebaseUser != null) {
          //Navigator.pushReplacementNamed(context, ChatRoomPage.routeName);
          Navigator.pushReplacementNamed(context, WelcomePage.routeName);
        }
      } on FirebaseException catch (error) {
        isUserLoggedIn = false;
        GlobalMethod.showErrorDialog(error: error.message!, ctx: context);
        rethrow;
      }
    }
    isUserLoggedIn = false;
  }
*/
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: CustomColors.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: 400,
            color: CustomColors.primaryColor,
            child: Form(
              key: _loginFormKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Login',
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
                    const SizedBox(height: 50),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: CustomColors.secondaryColor,
                          border: Border.all(color: Colors.blue)),
                      child: TextFormField(
                        controller: GlobalMethod.emailController,
                        validator: GlobalMethod.validateEmail,
                        onSaved: (newvalue) {
                          _users.userEmail = newvalue!;
                        },
                        style: GoogleFonts.openSans(color: Colors.white),
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            labelText: 'Email Address',
                            labelStyle:
                                GoogleFonts.openSans(color: Colors.white),
                            icon:
                                Icon(Icons.account_circle, color: Colors.white),
                            border: InputBorder.none),
                        textInputAction: TextInputAction.next,
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
                        obscureText: showPassword,
                        controller: GlobalMethod.passwordController,
                        validator: GlobalMethod.validatePassword,
                        onSaved: (newvalue) {
                          _users.userPassword = newvalue!;
                        },
                        style: GoogleFonts.openSans(color: Colors.white),
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(
                                  (showPassword)
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Color.fromRGBO(255, 63, 111, 1),
                                ),
                                onPressed: () {
                                  setState(() {
                                    showPassword = !showPassword;
                                  });
                                }),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            labelText: 'Password',
                            labelStyle:
                                GoogleFonts.openSans(color: Colors.white),
                            icon: Icon(Icons.lock, color: Colors.white),
                            border: InputBorder.none),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgetPasswordScreen(),
                                ),
                              );
                            },
                            child: const Text('Forget Password'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    MaterialButton(
                      elevation: 0,
                      minWidth: double.maxFinite,
                      height: 50,
                      onPressed: () {
                        _loginUser();
                      },
                      color: CustomColors.logoGreen,
                      child: Text('Login',
                          style: GoogleFonts.openSans(
                              color: Colors.white, fontSize: 16)),
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
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Don\'t have an account',
                              style: GoogleFonts.openSans(
                                  color: Colors.white, fontSize: 14),
                            ),
                            TextSpan(text: '    '),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignUp(),
                                    ),
                                  );
                                },
                              text: 'Register',
                              style: GoogleFonts.openSans(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue.shade300,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //const SizedBox(height: 5),
                    //Padding(
                    //  padding: const EdgeInsets.all(8.0),
                    //  child: Text(GlobalMethod.errorMsg,
                    //      style:
                    //          const TextStyle(color: Colors.red, fontSize: 20)),
                    //),
                    const SizedBox(height: 5),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: GlobalMethod.buildFooterLogo())
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
