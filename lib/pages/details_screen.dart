import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  //const UserDetails({Key? key}) : super(key: key);
  static const String routeName = "\details_page";

  @override
  _DetailsStateScreen createState() => _DetailsStateScreen();
}

class _DetailsStateScreen extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details Page'),
      ),
    );
  }
}
