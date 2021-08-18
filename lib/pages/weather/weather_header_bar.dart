import 'package:flutter/material.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../auth/login_page.dart';
import '../../auth/firebase_auth_service.dart';
import '../../utils/constants.dart';
import '../../utils/custom_color.dart';
import '../../utils/responsive_screen.dart';

class WeatherHeaderBar extends StatelessWidget {
  const WeatherHeaderBar({
    Key? key,
    required GlobalKey<ScaffoldState> scaffoldKey,
  })  : _scaffoldKey = scaffoldKey,
        super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Constants.kDefaultPadding),
      child: Row(
        children: [
          // Once user click the menu icon the menu shows like drawer
          // Also we want to hide this menu icon on desktop
          //if (!Responsive.isDesktop(context))
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
          ),
          if (!Responsive.isDesktop(context)) SizedBox(width: 5),
          Expanded(
            child: TextField(
              onChanged: (value) {},
              decoration: InputDecoration(
                hintText: "Search",
                fillColor: CustomColors.kBgLightColor,
                filled: true,
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(
                      Constants.kDefaultPadding * 0.75), //15
                  child: WebsafeSvg.asset(
                    "assets/Icons/Search.svg",
                    width: 24,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          if (!Responsive.isDesktop(context)) SizedBox(width: 5),
          IconButton(
              onPressed: () {
                //FirebaseAuthService.logoutUser(context: context);
                Navigator.pushReplacementNamed(context, LoginPage.routeName);
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
    );
  }
}
