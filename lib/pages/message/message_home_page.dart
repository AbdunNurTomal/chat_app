import 'package:chat_app/component/side_menu.dart';
import 'package:chat_app/pages/message/chat_room_page.dart';
import 'package:chat_app/utils/responsive_screen.dart';
import 'package:flutter/material.dart';
import 'list_user_in_message_screen.dart';

class MessageHomePage extends StatefulWidget {
  static const String routeName = "\message_home_page";

  @override
  _MessageHomePageState createState() => _MessageHomePageState();
}

class _MessageHomePageState extends State<MessageHomePage> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: ListUserInMessageScreen(),
        tablet: Row(
          children: [
            Expanded(
              flex: 6,
              child: ListUserInMessageScreen(),
            ),
            Expanded(
              flex: 9,
              child: ChatRoomPage(),
            ),
          ],
        ),
        desktop: Row(
          children: [
            // Once our width is less then 1300 then it start showing errors
            // Now there is no error if our width is less then 1340
            Expanded(
              flex: _size.width > 1340 ? 2 : 4,
              child: SideMenu(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 3 : 5,
              child: ListUserInMessageScreen(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 8 : 10,
              child: ChatRoomPage(),
            ),
          ],
        ),
      ),
    );
  }
}
