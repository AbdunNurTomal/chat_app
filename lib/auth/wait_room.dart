import 'package:chat_app/utils/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WaitingRoom extends StatelessWidget {
  //const WaitingRoom({Key? key}) : super(key: key);
  static const String routeName = "\waiting_page";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Dialog(
      insetPadding: const EdgeInsets.all(0.0),
      backgroundColor: CustomColors.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hello',
                  textAlign: TextAlign.center,
                  style:
                      GoogleFonts.openSans(color: Colors.white, fontSize: 32),
                ),
                const SizedBox(height: 20),
                Text(
                  'Welcome to PQC',
                  textAlign: TextAlign.center,
                  style:
                      GoogleFonts.openSans(color: Colors.white, fontSize: 28),
                ),
                const SizedBox(height: 20),
                Text(
                  'Please wait for Admin approval',
                  textAlign: TextAlign.center,
                  style:
                      GoogleFonts.openSans(color: Colors.white, fontSize: 28),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
