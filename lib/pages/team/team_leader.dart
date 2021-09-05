import 'package:flutter/material.dart';

class TeameLeaderPage extends StatefulWidget {
  //const AdminHomePage({Key? key}) : super(key: key);
  static const String routeName = "\team_leader";

  @override
  _TeameLeaderPageState createState() => _TeameLeaderPageState();
}

class _TeameLeaderPageState extends State<TeameLeaderPage> {
  @override
  Widget build(BuildContext context) {
    print("TeamLeader>>");
    return Scaffold(
      appBar: AppBar(
        title: Text('Team Leader Home Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('TEAM LEADER',
              style: TextStyle(color: Colors.white, fontSize: 13)),
        ],
      ),
    );
  }
}
