import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:chat_app/models/defect.dart';
import 'package:chat_app/utils/image_full_screen_wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uri_to_file/uri_to_file.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as IMG;

class DefectImageForm extends StatefulWidget {
  final int ddItemValue;
  final String ddItem;
  final ValueChanged<int> onChangedDDItemValue;
  final ValueChanged<String> onChangedDDItem;
  final VoidCallback onSavedItem;

  const DefectImageForm({
    Key? key,
    this.ddItemValue=0,
    this.ddItem='',
    required this.onChangedDDItemValue,
    required this.onChangedDDItem,
    required this.onSavedItem,
  }) : super(key: key);

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
  var selectedItem;
  //Defects defect = Defects();
  late Defects defect;

  late Uint8List _imageByteslist;

  String? dropdownValue;

  bool _imagePickButton = false;
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
        stream: FirebaseFirestore.instance.collection('defect_items').snapshots(),
        builder: (context, snapshot){
          if (!snapshot.hasData) {
            return const Text("Loading.....");
          }else{
            List<DropdownMenuItem> _queryCat = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              DocumentSnapshot snap = snapshot.data!.docs[i];
              //print("Snap ${snap.data()}");
              defect = Defects.fromMap(snap.data() as Map<String, dynamic>);
              //print("Defect >> ${defect.itemName}");
              _queryCat.add(
                DropdownMenuItem(
                  child: Text(
                    defect.itemName,
                    style: const TextStyle(color: Colors.black),
                  ),
                  value: "${defect.itemNumber}",
                ),
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(FontAwesomeIcons.coins,
                    size: 20.0, color: Colors.white),
                const SizedBox(width: 10.0),
                DropdownButton<dynamic>(
                  items: _queryCat,
                  onChanged: (_queryItem) {
                    const snackBar = SnackBar(
                      content: Text(
                        'Selected defect item',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    setState(() {
                      _imagePickButton = true;
                      selectedItem = _queryItem;
                    });
                  },
                  value: selectedItem,
                  isExpanded: false,
                  hint: const Text(
                    "Selected defect item",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            );
          }
        }
    );
  }

  Widget buildDDButton() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.lightBlueAccent,
            width: 2,
          ),
          color: Colors.lightBlue,
          //borderRadius: BorderRadius.circular(5)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: ddItemFromFirebase(),
    /*

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
*/
          ),
          Container(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: (_imagePickButton) ? loadAssets : null,
              child: const Text("Pick"),
              style: ElevatedButton.styleFrom(primary: Colors.orange, onPrimary: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
  Widget buildGridView() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black12,
            width: 2,
          ),
          color: Colors.black54,
          //borderRadius: BorderRadius.circular(5)
      ),
      child: Stack(
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

                          //final myImagePath = _getDirectoryPath();
                          //var kompresimg = File("$myImagePath/$imageName")
                          //  ..writeAsBytesSync(_file!.encodeJpg(gambarKecilx, quality: 95));

                          //await _file!.copy("$myImagePath/$imageName");

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
      ),
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
          buildDDButton(),
          //const SizedBox(height: 5.0),
          buildGridView(),
          //const SizedBox(height: 5.0),
        ],
    );
  }
}

