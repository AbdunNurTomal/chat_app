import 'package:flutter/material.dart';
import 'dart:async';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class TeameLeaderPage extends StatefulWidget {
  //const AdminHomePage({Key? key}) : super(key: key);
  static const String routeName = "\team_leader";

  @override
  _TeameLeaderPageState createState() => _TeameLeaderPageState();
}

class _TeameLeaderPageState extends State<TeameLeaderPage> {
  List<Asset> images = <Asset>[];
  String _error = 'Selectionner une image';

  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Fatto",
        ),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

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
          Center(child: Text('Error: $_error')),
          ElevatedButton(
            child: Text("Pick images"),
            onPressed: loadAssets,
          ),
          Expanded(
            child: buildGridView(),
          )
        ],
      ),
    );
  }
}
