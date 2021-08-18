import 'utils/constants.dart';
import 'utils/custom_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'component/side_menu.dart';
import 'utils/responsive_screen.dart';

class WelcomePage extends StatelessWidget {
  //const WelcomePage({Key? key}) : super(key: key);
  static const String routeName = "\welcome_page";

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
                // This is our bar
                Row(
                  children: [
                    // Once user click the menu icon the menu shows like drawer
                    // Also we want to hide this menu icon on desktop
                    if (!Responsive.isDesktop(context))
                      IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () {
                          _scaffoldKey.currentState!.openDrawer();
                        },
                      ),
                    if (!Responsive.isDesktop(context)) SizedBox(width: 5),
                    Expanded(
                      child: Text('Welcome To Team'),
                    ),
                  ],
                ),
                SizedBox(height: Constants.kDefaultPadding),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Constants.kDefaultPadding),
                  child: Text('Hello Universe'),
                ),
              ],
            ),
          ),
        ));
  }
}
