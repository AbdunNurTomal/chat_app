import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../component/side_menu.dart';
import '../../pages/weather/weather_header_bar.dart';
import '../../utils/constants.dart';
import '../../utils/custom_color.dart';

class WeatherPage extends StatefulWidget {
  //const WeatherPage({Key? key}) : super(key: key);
  static const String routeName = "\weather_page";

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
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
            child: Column(children: [
              // This is our Header bar
              WeatherHeaderBar(scaffoldKey: _scaffoldKey),

              SizedBox(height: Constants.kDefaultPadding),
              Text('Weather Page')
            ]),
          ),
        ));
  }
}
