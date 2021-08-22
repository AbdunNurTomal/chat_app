import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_color.dart';

class GlobalMethod {
  //static String errorMsg = '';
  static dynamic screenSize(
      {required context, required String sizeWidthHeight}) {
    Size size = MediaQuery.of(context).size;
    return (sizeWidthHeight == 'width') ? size.width : size.height;
  }

  static void showErrorDialog(
      {required String error, required BuildContext ctx}) {
    showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    'https://image.flaticon.com/icons/png/128/1252/1252006.png',
                    height: 20,
                    width: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Error occured ',
                  ),
                ),
              ],
            ),
            content: Text(
              '$error',
              style: TextStyle(
                color: CustomColors.darkBlue,
                fontSize: 20,
                //fontStyle: FontStyle.italic
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        });
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static String? validateEmail(String value) {
    value = value.trim();
    if (value.isNotEmpty) {
      if (value.isEmpty) {
        return 'Email can\'t be empty';
      } else {
        if (!value.contains(RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r"{0,253}[a-zA-Z0-9])?)*$"))) {
          return 'Enter a correct email address';
        } else {
          return null;
        }
      }
    }
    return null;
  }

  //^(?:\+?88|0088)?01[15-9]\d{8}$
  static String? validatePhone(String value) {
    value = value.trim();
    if (value.isNotEmpty) {
      if (value.isEmpty) {
        return 'Phone can\'t be empty';
      } else if (value.length < 11) {
        return 'Length of phone should be 11';
      } else {
        if (!value.contains(RegExp(r"^(?:\+?88|0088)?01[15-9]\d{8}$"))) {
          return 'Enter a correct phone number';
        } else {
          return null;
        }
      }
    }
    return null;
  }

  static String? validatePassword(String value) {
    value = value.trim();
    if (value.isNotEmpty) {
      if (value.isEmpty) {
        return 'Password can\'t be empty';
      } else if (value.length < 6) {
        return 'Length of password should be greater than 6';
      } else {
        if (!value.contains(RegExp(
            r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~.]).{8,}$"))) {
          return 'Enter valid password';
        } else {
          return null;
        }
      }
    }
  }

  static buildFooterLogo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset('images/pqc.png', height: 40),
        Text('Team & Co. Ltd',
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}
