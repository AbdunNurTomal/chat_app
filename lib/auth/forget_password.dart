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
  late TextEditingController _forgetPassTextController =
      TextEditingController(text: '');

  @override
  void dispose() {
    _forgetPassTextController.dispose();
    super.dispose();
  }

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Forget password',
                  textAlign: TextAlign.center,
                  style:
                      GoogleFonts.openSans(color: Colors.white, fontSize: 28),
                ),
                SizedBox(height: 20),
                Text(
                  'Enter yout Email address',
                  textAlign: TextAlign.center,
                  style:
                      GoogleFonts.openSans(color: Colors.white, fontSize: 14),
                ),
                SizedBox(height: 20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: CustomColors.secondaryColor,
                      border: Border.all(color: Colors.blue)),
                  child: TextFormField(
                    controller: _forgetPassTextController,
                    style: GoogleFonts.openSans(color: Colors.white),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        labelText: 'Email Address',
                        labelStyle: GoogleFonts.openSans(color: Colors.white),
                        icon: Icon(Icons.email, color: Colors.white),
                        border: InputBorder.none),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide a valid email address.';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 50),
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
                SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Remebered password',
                        style: GoogleFonts.openSans(
                            color: Colors.white, fontSize: 14),
                      ),
                      TextSpan(text: '    '),
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
        )));
  }

  void _forgetPasFCT() {
    print('_forgetPassTextController.text ${_forgetPassTextController.text}');
  }
}
