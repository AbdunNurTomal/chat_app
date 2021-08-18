import 'package:flutter/material.dart';

import '../component/side_menu.dart';
import '../pages/details_screen.dart';
import '../utils/responsive_screen.dart';
import 'list_screen.dart';

class HomePage extends StatefulWidget {
  //const HomePage({Key? key}) : super(key: key);
  static const String routeName = "\home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: ListScreen(),
        tablet: Row(
          children: [
            Expanded(
              flex: 6,
              child: ListScreen(),
            ),
            Expanded(
              flex: 9,
              child: DetailsScreen(),
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
              child: ListScreen(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 8 : 10,
              child: DetailsScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
