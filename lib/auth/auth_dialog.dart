import 'package:chat_app/models/user.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/global_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final Users _users = Users();

  FirebaseAuthService _authentication = FirebaseAuthService();
  final _loginFormKey = GlobalKey<FormState>();
  bool showPassword = true;

  final TextEditingController _emailTextController =
      TextEditingController(text: '');
  final TextEditingController _passTextController =
      TextEditingController(text: '');

  late FocusNode textFocusNodeEmail;
  late FocusNode textFocusNodePassword;
  //bool _isEditingEmail = false;
  //bool _isEditingPassword = false;
  //bool _isRegistering = false;
  //String? loginStatus;
  //Color loginStringColor = Colors.green;

  @override
  void dispose() {
    _emailTextController.dispose();
    _passTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
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
    //double? newSize;
    //if (Responsive.isDesktop(context) || Responsive.isTablet(context)) {
    //  newSize = 400.0;
    //}else if (Responsive.isMobile(context)){
    //  newSize = MediaQuery.of(context).size.width;
    //}
    //print("New Size is : $newSize");
    return SafeArea(
      child: Dialog(
        insetPadding: const EdgeInsets.all(0.0),
        backgroundColor: CustomColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: Constants.kDefaultSizeWidth,
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
                          controller: _emailTextController,
                          validator: (value) =>
                              GlobalMethod.validateEmail(value!),
                          onSaved: (value) {
                            _users.userEmail = value!;
                          },
                          style: GoogleFonts.openSans(color: Colors.white),
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              labelText: 'Email Address',
                              labelStyle:
                                  GoogleFonts.openSans(color: Colors.white),
                              icon: const Icon(Icons.account_circle,
                                  color: Colors.white),
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
                          controller: _passTextController,
                          validator: (value) =>
                              GlobalMethod.validatePassword(value!),
                          onSaved: (value) {
                            _users.userPassword = value!;
                          },
                          style: GoogleFonts.openSans(color: Colors.white),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  icon: Icon(
                                    (showPassword)
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color:
                                        const Color.fromRGBO(255, 63, 111, 1),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  }),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              labelText: 'Password',
                              labelStyle:
                                  GoogleFonts.openSans(color: Colors.white),
                              icon: const Icon(Icons.lock, color: Colors.white),
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
                                    builder: (context) =>
                                        ForgetPasswordScreen(),
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
                            //GlobalMethod.showErrorDialog(error: 'Error initializing Firebase', ctx: context);
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
                              const TextSpan(text: '    '),
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
      ),
    );
  }
}
