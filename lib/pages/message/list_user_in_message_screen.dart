import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../component/side_menu.dart';
import '../../pages/message/list_user_in_message_header_screen.dart';
import '../../utils/constants.dart';
import '../../utils/custom_color.dart';

class ListUserInMessageScreen extends StatefulWidget {
  static const String routeName = "\list_of_users";

  @override
  _ListUserInMessageStateScreen createState() =>
      _ListUserInMessageStateScreen();
}

class _ListUserInMessageStateScreen extends State<ListUserInMessageScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Column(
            children: [
              // This is our Seearch bar
              ListUserInMessageHeaderScreen(scaffoldKey: _scaffoldKey),
              SizedBox(height: Constants.kDefaultPadding),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Constants.kDefaultPadding),
                child: Row(
                  children: [
                    WebsafeSvg.asset(
                      "assets/Icons/Angle down.svg",
                      width: 16,
                      color: Colors.black,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Sort by user",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Spacer(),
                    MaterialButton(
                      minWidth: 20,
                      onPressed: () {},
                      child: WebsafeSvg.asset(
                        "assets/Icons/Sort.svg",
                        width: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Constants.kDefaultPadding),
              //Expanded(
              //  child: ListView.builder(
              //    itemCount: emails.length,
              //    // On mobile this active dosen't mean anything
              //    itemBuilder: (context, index) => EmailCard(
              //      isActive: Responsive.isMobile(context) ? false : index == 0,
              //      email: emails[index],
              //      press: () {
              //        Navigator.push(
              //          context,
              //          MaterialPageRoute(
              //            builder: (context) =>
              //                EmailScreen(email: emails[index]),
              //          ),
              //        );
              //      },
              //    ),
              //  ),
              //),
            ],
          ),
        ),
      ),
    );
  }
}
