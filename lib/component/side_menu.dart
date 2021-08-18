import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../component/side_menu_item.dart';
import '../pages/home_page.dart';
import '../pages/message/message_home_page.dart';
import '../pages/weather/weather_page.dart';
import '../utils/constants.dart';
import '../utils/custom_color.dart';
import '../utils/responsive_screen.dart';

class SideMenu extends StatefulWidget {
  //const SideMenu({Key? key}) : super(key: key);
  static const String routeName = "\side_menu";

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: EdgeInsets.only(top: kIsWeb ? Constants.kDefaultPadding : 0),
      color: CustomColors.kBgLightColor,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: Constants.kDefaultPadding),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/images/pqc.png",
                    width: 46,
                  ),
                  Spacer(),
                  // We don't want to show this close button on Desktop mood
                  if (!Responsive.isDesktop(context)) CloseButton(),
                ],
              ),
              SizedBox(height: Constants.kDefaultPadding),
              // Menu Items
              SideMenuItem(
                press: () {
                  Navigator.pushReplacementNamed(
                      context, WeatherPage.routeName);
                },
                title: "Weather",
                iconSrc: "assets/Icons/Inbox.svg",
                isActive: true,
                itemCount: 0,
              ),
              SideMenuItem(
                press: () {
                  Navigator.pushReplacementNamed(
                      context, MessageHomePage.routeName);
                },
                title: "Message",
                iconSrc: "assets/Icons/Send.svg",
                isActive: false,
                itemCount: 0,
              ),
              SideMenuItem(
                press: () {},
                title: "Contact",
                iconSrc: "assets/Icons/File.svg",
                isActive: false,
                itemCount: 0,
              ),
              SideMenuItem(
                press: () {
                  Navigator.pushReplacementNamed(context, HomePage.routeName);
                },
                title: "Users",
                iconSrc: "assets/Icons/File.svg",
                isActive: false,
                itemCount: 2,
                showBorder: false,
              ),

              SizedBox(height: Constants.kDefaultPadding * 2),
              // Tags
              //Tags(),
            ],
          ),
        ),
      ),
    );
  }
}
