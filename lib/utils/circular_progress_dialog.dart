import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DialogCircularBuilder {
  DialogCircularBuilder(this.context);

  final BuildContext context;

  void showLoadingIndicator({required int value, required String text}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))
              ),
              backgroundColor: Colors.black87,
              content: LoadingIndicator(
                  value: value,
                  text: text
              ),
            )
        );
      },
    );
  }

  void hideOpenDialog() {
    Navigator.of(context).pop();
  }
}

class LoadingIndicator extends StatelessWidget{
  LoadingIndicator({this.value=0, this.text = ''});

  final int value;
  final String text;

  @override
  Widget build(BuildContext context) {
    var displayedText = text;

    return Container(
        padding: EdgeInsets.all(16),
        color: Colors.black87,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _getLoadingIndicator(value),
              _getHeading(context),
              // _getText(displayedText)
            ]
        )
    );
  }

  Padding _getLoadingIndicator(int value) {
    return Padding(
        child: Container(
          child: CircularProgressIndicator(
            strokeWidth: 13,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
          width: 102,
          height: 102,
        ),

        // CircularPercentIndicator(
        //   radius: 180.0,
        //   lineWidth: 13.0,
        //   animation: true,
        //   percent: 0.5,
        //   center: Text(
        //     value.toString(),
        //     style:
        //     TextStyle(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0),
        //   ),
        //   footer: const Padding(
        //     padding: EdgeInsets.all(8.0),
        //     child: Text(
        //       "Please wait …",
        //       style:
        //       TextStyle(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 25.0),
        //     ),
        //   ),
        //   circularStrokeCap: CircularStrokeCap.round,
        //   progressColor: Colors.orange,
        // ),
        padding: EdgeInsets.only(bottom: 16)
    );
  }

  Widget _getHeading(context) {
    return const Padding(
          child: Text(
            'Please wait …',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16
            ),
            textAlign: TextAlign.center,
          ),
          padding: EdgeInsets.only(bottom: 4)
      );
  }

  Text _getText(String displayedText) {
    return Text(
      displayedText,
      style: const TextStyle(
          color: Colors.white,
          fontSize: 14
      ),
      textAlign: TextAlign.center,
    );
  }
}