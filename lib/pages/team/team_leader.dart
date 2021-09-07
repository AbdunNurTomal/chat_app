import 'dart:async';
import 'dart:io';

import 'package:chat_app/utils/image_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:chat_app/utils/image_full_screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:uri_to_file/uri_to_file.dart';

class TeameLeaderPage extends StatefulWidget {
  //const AdminHomePage({Key? key}) : super(key: key);
  static const String routeName = "\team_leader";

  @override
  _TeameLeaderPageState createState() => _TeameLeaderPageState();
}
/*
class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile({required String fileLocation}) async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
}
*/
class _TeameLeaderPageState extends State<TeameLeaderPage> {
  List<Asset> images = <Asset>[];
  //List<File>files = <File>[];
  File? _file;
  String _error = 'No Error Detected Test';
  //late final CounterStorage storage;

  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    return ListView(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      children: <Widget>[
        SizedBox(height: 10.0),
        Container(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 1,
            physics: ScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  Container(
                    height: 50.0,
                    color: Colors.green,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(Icons.format_list_numbered,
                            color: Colors.white),
                        Padding(
                            padding: EdgeInsets.only(right: 5.0)),
                        Text('List Item',
                            style: TextStyle(
                                fontSize: 20.0, color: Colors.white)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 150.0,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        Asset asset = images[index];
                        print("name ${asset.name}");
                        print("identifier ${asset.identifier}");
                        return Card(
                          elevation: 5.0,
                          child: InkWell(
                            onTap: ()async {
                              String? imageUri = images[index].identifier;
                              //Uri? _uri = Uri.parse(imageUri!);
                              //print("Uri - $_uri");
                              //_file = await toFile(_uri);
                              //print("File - $_file");

                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => ImageDialog(
                                    imageUri: imageUri!,
                                    tag: "generate_a_unique_tag",
                                  ),
                                ));
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.width / 3,
                              width: MediaQuery.of(context).size.width / 3,
                              alignment: Alignment.center,
                              child: AssetThumb(
                                asset: asset,
                                width: 300,
                                height: 300,
                                quality: 75,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10.0),
                ],
              );
            },
          ),
        ),
      ],
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
        title: const Text('Team Leader Home Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('TEAM LEADER',
              style: TextStyle(color: Colors.white, fontSize: 13)),
          Center(child: Text('Error: $_error')),
          ElevatedButton(
            child: const Text("Pick images"),
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
