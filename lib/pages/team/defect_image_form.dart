import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:chat_app/auth/firebase_auth_service.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/custom_color.dart';
import 'package:chat_app/utils/image_full_screen_wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uri_to_file/uri_to_file.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as IMG;

class DefectImageForm extends StatefulWidget {
  //String defectItemName;
  //DefectImageForm({Key? key, required this.defectItemName}) : super(key: key);
  const DefectImageForm({Key? key}) : super(key: key);

  @override
  State<DefectImageForm> createState() => _DefectImageFormState();
}
class Item {
  const Item(this.name,this.icon);
  final String name;
  final Icon icon;
}
class _DefectImageFormState extends State<DefectImageForm> {
  late Item selectedUser;
  String _error = 'No Problem';
  List<Asset> images = <Asset>[];
  //List<File>files = <File>[];
  File? _file;
  //late final CounterStorage storage;

  late Uint8List _imageByteslist;

  @override
  void initState() {
    super.initState();
  }

  Future<String> _getDirectoryPath() async{
    final directory = await getExternalStorageDirectory();
    final myImagePath = '${directory?.path}/MyImages';
    final myImgDir = await Directory(myImagePath).create();

    return myImagePath;
  }

  Future<ui.Image> loadImage(Uint8List bytes) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(bytes, (ui.Image img) => completer.complete(img));
    return completer.future;
  }
  Future<ui.Image> resizeImage(Uint8List data) async {
    Uint8List? resizedData = data;
    IMG.Image? img = IMG.decodeImage(data);
    IMG.Image resized = IMG.copyResize(img!, width: 325, height: 265);
    resizedData = IMG.encodeJpg(resized) as Uint8List?;

    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(resizedData!, (ui.Image img) => completer.complete(img));
    return completer.future;
  }

  Widget ddItemFromFirebase(){
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('defect_descriptions').snapshots(),
        builder: (context, snapshot){
          if (snapshot.hasData) {
            var length = snapshot.data!.docs.length;
            DocumentSnapshot ds = snapshot.data!.docs[length - 1];
            _queryCat = snapshot.data!.docs;
            return new Container(
              padding: EdgeInsets.only(bottom: 16.0),
              width: screenSize.width*0.9,
              child: new Row(
                children: <Widget>[
                  new Expanded(
                      flex: 2,
                      child: new Container(
                        padding: EdgeInsets.fromLTRB(12.0,10.0,10.0,10.0),
                        child: new Text("Category",style: textStyleBlueBold,),
                      )
                  ),
                  new Expanded(
                    flex: 4,
                    child:new InputDecorator(
                      decoration: const InputDecoration(
                        //labelText: 'Activity',
                        hintText: 'Select a defect description',
                        hintStyle: TextStyle(
                          color: primaryColor,
                          fontSize: 16.0,
                          fontFamily: "OpenSans",
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      isEmpty: _category == null,
                      child: new DropdownButton(
                        value: _category,
                        isDense: true,
                        onChanged: (String newValue) {
                          setState(() {
                            _category = newValue;
                            dropDown = false;
                            print(_category);
                          });
                        },
                        items: snapshot.data!.docs.map((DocumentSnapshot document) {
                          return new DropdownMenuItem<String>(
                              value: document.data['title'],
                              child: new Container(
                                decoration: new BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: new BorderRadius.circular(5.0)
                                ),
                                height: 100.0,
                                padding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 0.0),
                                //color: primaryColor,
                                child: new Text(document.data['title'],style: textStyle),
                              )
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }
    );
  }

  Widget buildDDButton() {
    String? dropdownValue;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          /*
                      Container(
                        height: 40.0,
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

                       */
          Container(
            alignment: Alignment.centerLeft,
            child: DropdownButton<String>(
              value: dropdownValue,
              hint: const Text('Select a defect description'),
              icon: const Icon(Icons.arrow_drop_down),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: <String>['Red', 'Green', 'Blue']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          const Expanded(child: Divider()),
          Container(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              child: const Text("Pick"),
              onPressed: loadAssets,
            ),
          ),
        ],
      ),
    );
  }
  Widget buildGridView() {
    return Stack(
      children: [
        Container(
          color: Colors.black26,
        ),
        SizedBox(
              height: 150.0,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  Asset asset = images[index];
                  //print("name ${asset.name}");
                  //print("identifier ${asset.identifier}");
                  return Card(
                    elevation: 5.0,
                    child: InkWell(
                      onTap: ()async {
                        String? imageName = images[index].name;
                        String? imageUri = images[index].identifier;
                        Uri? _uri = Uri.parse(imageUri!);
                        //print("Uri - $_uri");
                        _file = await toFile(_uri);

                        final myImagePath = _getDirectoryPath();
                        //var kompresimg = File("$myImagePath/$imageName")
                        //  ..writeAsBytesSync(_file!.encodeJpg(gambarKecilx, quality: 95));

                        await _file!.copy("$myImagePath/$imageName");

                        //File imageFile = File.fromUri(_uri);
                        //print("File - $_file");
                        Uint8List _imageByteslist = await _file!.readAsBytes();
                        //print("ImageByteslist - $_imageByteslist");
                        //await _file!.readAsBytes().then((value){
                        //_imageByteslist = Uint8List.fromList(value);
                        //print("ImageByteslist - $_imageByteslist");
                        //}).catchError((onError){
                        //  print('Exception error reading image file ' + onError.toString());
                        //});

                        try{
                          final ui.Image _myBackgroundImage;
                          _myBackgroundImage = await loadImage(_imageByteslist);
                          //print("MyBackgroundImage - $_myBackgroundImage");
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ImageDialogOld(
                                myBackgroundImage: _myBackgroundImage,
                                //imageUri: _file,
                                imageUri: imageUri,
                                tag: "generate_a_unique_tag",
                              ),
                              )
                          );
                        } catch (e) {
                          print(e);
                        }
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
      ]
    );//const SizedBox(height: 10.0),
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
    return Column(
        children: [
          Container(
            child: buildDDButton(),
            color: Colors.lightBlue,
          ),
          const SizedBox(height: 5.0),
          Container(
              child: buildGridView(),
              color: Colors.black54,
          ),
          const SizedBox(height: 5.0),
        ],
    );
  }
}
