import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../auth/firebase_auth_service.dart';
import '../../component/side_menu.dart';
import '../../auth/login_page.dart';
import '../../pages/message/message_header_bar.dart';
import '../../utils/constants.dart';
import '../../utils/custom_color.dart';

class ChatRoomPage extends StatefulWidget {
  static const String routeName = "\chat_room";

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chat Room'),
          actions: [
            IconButton(
                onPressed: () {
                  //FirebaseAuthService.logoutUser(context: context);
                  Navigator.pushReplacementNamed(context, LoginPage.routeName);
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        key: _scaffoldKey,
        drawer: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 250),
          child: SideMenu(),
        ),
        body: Container(
          padding: EdgeInsets.only(top: kIsWeb ? Constants.kDefaultPadding : 0),
          color: CustomColors.kBgDarkColor,
          child: SafeArea(
            right: false,
            child: Column(children: [
              // This is our Header bar
              MessageHeaderBar(scaffoldKey: _scaffoldKey),

              SizedBox(height: Constants.kDefaultPadding),
              Text('Chat Room Page')
            ]),
          ),
        ));
  }
}
