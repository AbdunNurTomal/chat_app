//import 'dart:async';
//import 'dart:io';
//import 'dart:typed_data';
//import 'dart:ui' as ui;

//import 'package:chat_app/models/defect.dart';
//import 'package:chat_app/utils/image_full_screen_wrapper.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:image/image.dart' as IMG;

//import 'package:chat_app/models/dynamic_list.dart';
import 'package:chat_app/models/defect.dart';
import 'package:chat_app/models/list_item.dart';
import 'package:chat_app/pages/report/add_list_item_dialog_widget.dart';
import 'package:chat_app/pages/report/item_widget.dart';
import 'package:chat_app/pages/report/list_item_widget.dart';
import 'package:chat_app/provider/list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:provider/provider.dart';
//import 'package:uri_to_file/uri_to_file.dart';

import '../report/back_defect_image_form.dart';

class TeameLeaderPage extends StatefulWidget {
  static const String routeName = "\team_leader";

  @override
  _TeameLeaderPageState createState() => _TeameLeaderPageState();
}
class PopUpMenuConstants{
  static const String ProcessItem = 'Process';
  //static const String SecondItem = 'Second Item';
  //static const String ThirdItem = 'Third Item';

  static const List<String> choices = <String>[
    ProcessItem,
    //SecondItem,
    //ThirdItem,
  ];

}
class _TeameLeaderPageState extends State<TeameLeaderPage> {//with SingleTickerProviderStateMixin {
  int counter = 0;
  //bool processButton = false;
  //String _error = 'No Problem';
  // late ListProvider defectItemProvider = Provider.of<ListProvider>(context, listen: false);

  @override
  void initState() {
    DefectData.callDefect();
    super.initState();
  }

  void _showProcessDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return alert dialog object
        return AlertDialog(
          title: new Text('I am Title'),
          content: Container(
            height: 150.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Icon(Icons.toys),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: new Text(' First Item'),
                    ),
                  ],
                ),
                new SizedBox(
                  height: 20.0,
                ),
                new Row(
                  children: <Widget>[
                    new Icon(Icons.toys),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: new Text(' Second Item'),
                    ),
                  ],
                ),
                new SizedBox(
                  height: 20.0,
                ),
                new Row(
                  children: <Widget>[
                    new Icon(Icons.toys),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: new Text('Third Item'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          title: Row(
            children: [
              SizedBox(
                  width:20,
                  child:Image.asset("images/pqc.png")
              ),
              const SizedBox(width:10),
              const Text('Pictures Report Form'),
            ],
          ),
          actions: <Widget>[
            //IconButton(
            //  icon: const Icon(Icons.add),
            //  tooltip: 'Add form field',
              //onPressed: () {
                //ScaffoldMessenger.of(context).showSnackBar(
                //  const SnackBar(
                //    content: Text('Trying to add field in form'),
                //  ),
                //);
                //taskItems.addItem(DefectImageForm(itemIndex: counter));

              //  const AddListItemDialogWidget();
              //},
            //  onPressed: () => showDialog(
            //    context: context,
            //    builder: (context) => AddListItemDialogWidget(),
            //    barrierDismissible: false,
            //  ),
            //),
            PopupMenuButton<String>(
              elevation: 20,
              enabled: true,
              onSelected: (value) {
                //setState(() {
                //  _value = value;
                //});
                switch(value){
                  case 'Process':
                    _showProcessDialog(context);
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return PopUpMenuConstants.choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ],
        ),

        floatingActionButton: FloatingActionButton(
          child: const Text(
            '+',
            style: TextStyle(fontSize: 20.0),
          ),
          shape: RoundedRectangleBorder(
              side: const BorderSide(
                  color: Colors.black26, width: 1.0, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(10.0)),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AddListItemDialogWidget(),
              barrierDismissible: false,
            ),
        ),

        /*
        body: Column(
            //key: _formKey,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child:
                (!processButtn) ? Text('Error: $_error'): ElevatedButton(
                  onPressed: (){

                  },
                  child: const Text("Process")
                ),
              ),
              Consumer<ListProvider>(builder: (context, provider, child) {
                return Expanded(
                  child: ListView.separated(
                    itemCount: listClass.length,
                    separatorBuilder: (context, index) => const Divider(
                        height: 8,
                        color: Colors.black,
                      ),
                    //itemBuilder: buildList,
                    itemBuilder: (context, index) {
                      final listItem = listClass[index];
                      return ListItemWidget(listItem: listItem);
                    },
                  ),
                );
              }),
            ],
          ),

       */
        body:  Container(
            //margin: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
                //border: Border.all(
                //  color: Colors.black12,
                //  width: 3,
                //),
                //borderRadius: BorderRadius.circular(5),
              color: Colors.black12,
            ),

            child: ListItemWidget()
        ),
    );
  }

/*
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

  var selectedItem;
  Defects defect = Defects();
  bool _imagePickButton = false;

  List<Asset> images = <Asset>[];
  File? _file;

  String? dropdownValue;
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
                    defect.itemName!,
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
        cupertinoOptions: const CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Fatto",
        ),
        materialOptions: const MaterialOptions(
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
*/
}
/*
class Item {
  const Item(this.name,this.icon);
  final String name;
  final Icon icon;
}
*/
