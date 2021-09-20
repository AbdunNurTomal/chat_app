import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:chat_app/models/defect.dart';
import 'package:chat_app/models/list_item.dart';
import 'package:chat_app/provider/list_provider.dart';
import 'package:chat_app/utils/image_full_screen_wrapper.dart';
import 'package:chat_app/utils/image_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:provider/provider.dart';
import 'package:uri_to_file/uri_to_file.dart';


class AddListItemDialogWidget extends StatefulWidget {
  const AddListItemDialogWidget({Key? key}) : super(key: key);

  @override
  _AddListItemDialogWidgetState createState() => _AddListItemDialogWidgetState();
}

class _AddListItemDialogWidgetState extends State<AddListItemDialogWidget> {
  final _formKey = GlobalKey<FormState>();
  String _error = 'No Problem';

  List<Asset> images = <Asset>[];
  File? _file;
  bool _imagePickButton = false;

  String ddItemValue = '';
  String ddItem = '';
  late ListProvider _defectProvider;
  final TextEditingController _ddIemController = TextEditingController();

  //late List<Defects> updatedDefect=[];

  static AnimationController? _animationController;
  // void Function(AnimationStatus) _statusListener;

  @override
  void initState() {
    super.initState();
    // _statusListener = (AnimationStatus status) {
    //   if (status == AnimationStatus.completed ||
    //       status == AnimationStatus.dismissed) {
    //     _suggestionsBoxController.resize();
    //   }
    //   _animationController!.addStatusListener(_statusListener);
    _defectProvider = Provider.of<ListProvider>(context,listen: false);

    // updatedDefect = _defectProvider.allListDefect;
  }

  @override
  void didChangeDependencies() {
    // _defectProvider = Provider.of<ListProvider>(context);
    // updatedDefect = _defectProvider.allListDefect;
    // print("updated defect : $updatedDefect");
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _ddIemController.dispose();
    // _animationController!.removeStatusListener(_statusListener);
    // _animationController!.dispose();
  }

  List<Defects> getSuggestions(String query) => List.of(DefectData.defect).where((updatedDefect) {
    final itemLower = updatedDefect.itemName.toLowerCase();
    final queryLower = query.toLowerCase();

    return itemLower.contains(queryLower);
  }).toList();

  @override
  Widget build(BuildContext context) {
    //print("Add List Item Dialog Widget");
    print("Defect : ${DefectData.defect}");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Pictures Item',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        actions: [
          IconButton(
              onPressed: _saveItem,
              icon: const Icon(Icons.save)
          )
        ],
      ),
      body: Builder(
      builder: (context) => Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //title
          Container(color: Colors.green,child: ddItemFromFirebase()),
          const SizedBox(height: 8),
          Container(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: (_imagePickButton) ? loadAssets : null,
              child: const Text("Pick"),
              style: ElevatedButton.styleFrom(
                  primary: Colors.orange, onPrimary: Colors.black),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: buildGridView()),
          //PicturesFormWidget(
          //  onChangedDDItemValue: (ddItemValue) =>
          //      setState(() => this.ddItemValue = ddItemValue),
          //  onChangedDDItem: (ddItem) =>
          //      setState(() => this.ddItem = ddItem),
          //onChangedDescription: (description) => setState(() => this.description = description),
          //  onSavedItem: addItem,
          //),
        ]
        ),
    ),
    ),
    );
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      //save data to database
      _formKey.currentState!.save();

      //print("ddItem >> $ddItem");
      final listItem = ListItem(
        id: DateTime.now().toString(),
        itemValue: ddItemValue,
        item: ddItem,
        images: images,
        //description: description,
        createdTime: DateTime.now(),
      );

      //print("listItem >> $listItem");
      //final provider = Provider.of<ListProvider>(context, listen: false);
      _defectProvider.addItem(listItem);
      DefectData.deleteDefectItem(ddItem);

      Navigator.of(context).pop();
    }
  }

  Widget ddItemFromFirebase() {
    return TypeAheadFormField(
      //hideSuggestionsOnKeyboardHide: false,
      hideOnEmpty: true,
      textFieldConfiguration: TextFieldConfiguration(
        autofocus: true,
        controller: _ddIemController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
          hintText: 'Enter a defect item',
          hintStyle: TextStyle(
              fontFamily: 'Metropolis-SemiBold',
              color: Colors.black87),
          ),
        ),
      suggestionsCallback: getSuggestions,
      itemBuilder: (context, Defects suggestion) {
        return ListTile(
          //leading: Text(suggestion.itemNumber),
          title: Text(suggestion.itemName),
        );
      },
      transitionBuilder: (context, suggestionsBox, _animationController) {
        return suggestionsBox;
        // return FadeTransition(
        //   child: suggestionsBox,
        //   opacity: CurvedAnimation(
        //       parent: _animationController,
        //       curve: Curves.fastOutSlowIn
        //   ),
        // );
      },
      noItemsFoundBuilder: (context) => Container(
        height: 40,
        child: const Center(
          child: Text(
            'No Defects Found.',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      onSuggestionSelected: (Defects suggestion) {
        _ddIemController.text = suggestion.itemName;
        setState((){_imagePickButton = true;});
        //Navigator.of(context).pop(null);
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please select a defect item';
        }
      },
      onSaved: (value) => ddItem = value!,
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
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: [
            GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                  childAspectRatio: 1,
                ),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  Asset asset = images[index];
                  //print("name ${asset.name}");
                  //print("identifier ${asset.identifier}");
                  return Card(
                    //clipBehavior: Clip.antiAlias,
                    elevation: 5.0,
                    child: Stack(
                      children: <Widget>[
                        InkWell(
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
                              _myBackgroundImage = await ImageUtility.loadImage(_imageByteslist);

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
                        Positioned(
                          right: 5,
                          top: 5,
                          child: InkWell(
                            child: const Icon(
                              Icons.remove_circle,
                              size: 20,
                              color: Colors.red,
                            ),
                            onTap: () {
                              setState(() {
                                //print("Remove");
                                images.removeAt(index);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
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

}