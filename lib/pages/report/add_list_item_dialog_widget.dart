import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:chat_app/models/defect.dart';
import 'package:chat_app/models/list_item.dart';
import 'package:chat_app/models/list_image_item.dart';
import 'package:chat_app/provider/list_provider.dart';
import 'package:chat_app/utils/circular_progress_dialog.dart';
import 'package:chat_app/utils/image_full_screen_wrapper.dart';
import 'package:chat_app/utils/image_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:uri_to_file/uri_to_file.dart';


class AddListItemDialogWidget extends StatefulWidget {
  AddListItemDialogWidget({Key? key}) : super(key: key);

  @override
  _AddListItemDialogWidgetState createState() => _AddListItemDialogWidgetState();
}

class _AddListItemDialogWidgetState extends State<AddListItemDialogWidget> {
  final _formKey = GlobalKey<FormState>();
  String _error = 'No Problem';

  List<Asset> images = <Asset>[];
  List<int> editedImage = [];

  bool _imagePickButton = false;

  String ddItemValue = '';
  String ddItem = '';
  late ListProvider _defectProvider;
  late int listLength;
  final TextEditingController _ddIemController = TextEditingController();

  //late List<Defects> updatedDefect=[];

  // static AnimationController? _animationController;
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
    listLength = _defectProvider.allListItem.length;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Pictures Item',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        actions: [
          IconButton(
              onPressed: (images.isNotEmpty)?_saveItem:null,
              icon: const Icon(Icons.save)
          )
        ],
      ),
      body: Builder(
      builder: (context) => Form(
      key: _formKey,
      child: Stack(
        children: <Widget>[
          Column(
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

        ],
      ),
    ),
    ),
    );
  }

  Future<void> _saveItem() async{
    _defectProvider.showCircularProgress(true);
    DialogCircularBuilder(context).showLoadingIndicator(value: _defectProvider.circularIndicator, text: '');
    // print("show circular : ${_defectProvider.circularIndicator}");

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if(images.isEmpty){
        Navigator.of(context).pop();
      }else {
        int counter =0;
        int addCounter = 0;
        final ui.Image _logoImage = await ImageUtility.loadUiImage('assets/images/pqc.png');
        for (int i = 0; i < images.length; i++) {
          ++counter;
          String? imageUri = images[i].identifier;
          String? imageName = images[i].name;
          String? itemName = "$ddItem\nNo-$counter";

          Uri _imageUri = Uri.parse(imageUri!);
          File _imageFile = await toFile(_imageUri);
          String _newImageName = "$ddItemValue\_$counter.jpg";
          int itemValue = int.parse(ddItemValue);

          if(await ImageUtility.saveImage(_imageFile, imageName!, itemName, _newImageName, _logoImage, itemValue)){
            ++addCounter;
          }
        }
        Fluttertoast.showToast(
            msg: "Added $addCounter Images",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );

        final listItem = ListItem(
          id: ddItemValue,
          itemValue: ddItemValue,
          item: ddItem,
          images: images,
          // edited: editedImage,
          //description: description,
          createdTime: DateTime.now(),
        );
        _defectProvider.addItem(listItem);

        DefectData.deleteDefectItem(ddItem);

        // for (var element in DefectImageData.allListImagesItem) {
        //   print("add element >>> ${element.oldImgName} & newImageName >>> ${element.newImgName} & proImageName >>> ${element.proImgName}");
        // }
      }
    }
    _defectProvider.showCircularProgress(false);
    DialogCircularBuilder(context).hideOpenDialog();
    Navigator.of(context).pop();
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
          // leading: Text(suggestion.itemNumber),
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
      noItemsFoundBuilder: (context) => const SizedBox(
        height: 40,
        child: Center(
          child: Text(
            'No Defects Found.',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      onSuggestionSelected: (Defects suggestion) {
        _ddIemController.text = "${suggestion.itemNumber}.${suggestion.itemName}";
        setState((){_imagePickButton = true;});
        //Navigator.of(context).pop(null);
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please select a defect item';
        }
      },
      onSaved: (value) {
        var splitValue = value!.split(".");
        ddItemValue = splitValue[0];
        ddItem = splitValue[1];
      },
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
                  return Card(
                    //clipBehavior: Clip.antiAlias,
                    elevation: 5.0,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.width / 3,
                          width: MediaQuery.of(context).size.width / 3,
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              AssetThumb(
                                asset: asset,
                                width: 300,
                                height: 300,
                                quality: 75,
                              ),
                              (editedImage.contains(index))?
                              const DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.black26,
                                ),
                                child: Center(
                                  child: Text("Edited",style: TextStyle(backgroundColor: Colors.white))                            ,
                                ),
                              ):Container(),
                            ],
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
                                editedImage.remove(index);
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
            actionBarTitle: "PQC",
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