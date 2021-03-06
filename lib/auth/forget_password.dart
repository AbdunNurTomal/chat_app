import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/global_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/custom_color.dart';

class ForgetPasswordScreen extends StatefulWidget {
  //const ForgetPassword({ Key? key }) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _forgetPasswordFormKey = GlobalKey<FormState>();

  final TextEditingController _forgetPassTextController =
      TextEditingController(text: '');

  @override
  void dispose() {
    _forgetPassTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Dialog(
            insetPadding: const EdgeInsets.all(0.0),
            backgroundColor: CustomColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Dialog(
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Forget password',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                              color: Colors.white, fontSize: 28),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Enter yout Email address',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                              color: Colors.white, fontSize: 14),
                        ),
                        const SizedBox(height: 20),
                        Form(
                          key: _forgetPasswordFormKey,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: CustomColors.secondaryColor,
                                border: Border.all(color: Colors.blue)),
                            child: TextFormField(
                              controller: _forgetPassTextController,
                              validator: (value) =>
                                  GlobalMethod.validateEmail(value!),
                              style: GoogleFonts.openSans(color: Colors.white),
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  labelText: 'Email Address',
                                  labelStyle:
                                      GoogleFonts.openSans(color: Colors.white),
                                  icon: const Icon(Icons.email,
                                      color: Colors.white),
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        MaterialButton(
                          elevation: 0,
                          minWidth: double.maxFinite,
                          height: 50,
                          onPressed: _forgetPasFCT,
                          color: CustomColors.logoGreen,
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text('Reset now',
                                style: GoogleFonts.openSans(
                                    color: Colors.white, fontSize: 16)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Remebered password',
                                style: GoogleFonts.openSans(
                                    color: Colors.white, fontSize: 14),
                              ),
                              const TextSpan(text: '    '),
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.canPop(context)
                                      ? Navigator.pop(context)
                                      : null,
                                text: 'Login',
                                style: GoogleFonts.openSans(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue.shade300,
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )))));
  }

  void _forgetPasFCT() async {
    final isValid = _forgetPasswordFormKey.currentState!.validate();
    if (!isValid) {
      GlobalMethod.showErrorDialog(error: "Validation Error", ctx: context);
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(
          email: _forgetPassTextController.text.trim().toLowerCase());
      print("Password reset email sent to ${_forgetPassTextController.text}");

      Navigator.canPop(context) ? Navigator.pop(context) : null;
    } on FirebaseException catch (error) {
      GlobalMethod.showErrorDialog(error: error.message!, ctx: context);
    }
  }
}
