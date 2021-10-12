import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:chat_app/models/defect.dart';
import 'package:chat_app/models/list_item.dart';
import 'package:chat_app/provider/list_provider.dart';
import 'package:chat_app/utils/circular_progress_dialog.dart';
import 'package:chat_app/utils/image_full_screen_wrapper.dart';
import 'package:chat_app/utils/image_util.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uri_to_file/uri_to_file.dart';


class EditListItemDialogWidget extends StatefulWidget {
  final ListItem listItem;
  EditListItemDialogWidget({Key? key, required this.listItem}) : super(key: key);

  @override
  _EditListItemDialogWidgetState createState() => _EditListItemDialogWidgetState();
}

class _EditListItemDialogWidgetState extends State<EditListItemDialogWidget> {
  final _formKey = GlobalKey<FormState>();
  String _error = 'No Problem';

  String ddItemValue = '';
  String ddItem = '';
  List<Asset> images = <Asset>[];
  List<bool> duplicateImg = [];
  List<bool> editedImage = [];
  bool deletedImage = false;

  late ListProvider _defectProvider;
  final TextEditingController _ddIemController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _defectProvider = Provider.of<ListProvider>(context,listen: false);
    _ddIemController.text = widget.listItem.item!;
    images = widget.listItem.images;
    ddItem = widget.listItem.item!;
    ddItemValue = widget.listItem.itemValue!;

    for (var element in DefectImageData.allListImagesItem) {
      editedImage.add(element.isImgEdited);
    }
  }

  @override
  void didChangeDependencies() {;
    super.didChangeDependencies();
    // _defectProvider = Provider.of<ListProvider>(context,listen: false);
    // if (images.isEmpty) {
    //   print("edit page >> ${widget.listItem}");
    //   _defectProvider.deleteItem(widget.listItem);
    // }
  }

  @override
  void dispose() {
    super.dispose();
    _ddIemController.dispose();
  }

  List<Defects> getSuggestions(String query) => List.of(DefectData.defect).where((defect) {
    final itemLower = defect.itemName.toLowerCase();
    final queryLower = query.toLowerCase();
    return itemLower.contains(queryLower);
  }).toList();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Fluttertoast.showToast(
            msg: "Please complete edit operation and save",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 20.0
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Edit Item',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(color: Colors.green,child: ddItemFromFirebase()),
                const SizedBox(height: 8),
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: loadAssets,
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
      ),
    );
  }

  void _saveItem() async{
    _defectProvider.showCircularProgress(true);
    DialogCircularBuilder(context).showLoadingIndicator(value: _defectProvider.circularIndicator, text: '');

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var duplicateImgMsgBuilder = StringBuffer();
      duplicateImgMsgBuilder.write("Duplicate pictures found\n");

      for (int i = 0; i < images.length; i++) {
        var foundIndexImg = DefectImageData.allListImagesItem.indexWhere((element) => (element.oldImgName == images[i].name));
        if(foundIndexImg>=0){
          var categoryPosition = DefectImageData.allListImagesItem[foundIndexImg].newImgName!.split('.').first;

          String _inCategory = categoryPosition.split('_').first;
          var _inPosition = categoryPosition.split('_').last;

          if(_inCategory != ddItemValue){
            duplicateImgMsgBuilder.write("> added in category $_inCategory and position $_inPosition\n");
            setState(() => duplicateImg[i] = true);
          }else{
            duplicateImg[i] = false;
          }
        }else{
          duplicateImg[i] = false;
        }
      }
      if(duplicateImg.contains(true)) {
        _defectProvider.showCircularProgress(false);
        DialogCircularBuilder(context).hideOpenDialog();

        Fluttertoast.showToast(
            msg: duplicateImgMsgBuilder.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );

        return;
      }


      String imageDir = await ImageUtility.getImageDirPath();
      int counter = 0;
      int addCounter = 0;
      final ui.Image _logoImage = await ImageUtility.loadUiImage('assets/images/pqc.png');

      for (int i = 0; i < images.length; i++) {
        ++counter;
        String _newImageName = "$ddItemValue\_$counter.jpg";
        String? imageUri = images[i].identifier;
        String? _imageName = images[i].name;
        String? _itemName = "$ddItem\nNo-$counter";

        if((DefectImageData.allListImagesItem.indexWhere((element) => (element.oldImgName == _imageName)))<0){
          Uri _imageUri = Uri.parse(imageUri!);
          File _imageFile = await toFile(_imageUri);

          int itemValue = int.parse(ddItemValue);

          if (await ImageUtility.saveImage(_imageFile, _imageName!, _itemName, _newImageName, _logoImage, itemValue)) {
            ++addCounter;
          }
        }else if((DefectImageData.allListImagesItem.indexWhere((element) => (element.newImgName == _newImageName)))<0){
          var _foundName = DefectImageData.allListImagesItem.indexWhere((element) => (element.oldImgName == _imageName));
          if(_foundName>=0){
            File('$imageDir/${DefectImageData.allListImagesItem[_foundName].proImgName}').renameSync('$imageDir/$_newImageName');
            DefectImageData.allListImagesItem[_foundName].newImgName = _newImageName;
            DefectImageData.allListImagesItem[_foundName].proImgName = _newImageName;
          }
        }
      }
      DefectImageData.allListImagesItem.sort((a,b) => a.newImgName!.compareTo(b.newImgName!));
      // for (var element in DefectImageData.allListImagesItem) {
      //   print("edited add element >>> ${element.oldImgName} & newImageName >>> ${element.newImgName} & proImageName >>> ${element.proImgName}");
      // }

      Fluttertoast.showToast(
          msg: (addCounter>0)?"Added $addCounter Item":"Updated Item",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );

      final updateListItem = ListItem(
        id: widget.listItem.id,
        itemValue: ddItemValue,
        item: ddItem,
        images: images,
        // edited: editedImage,
        createdTime: DateTime.now(),
      );
      _defectProvider.editItem(widget.listItem, updateListItem);
    }

    _defectProvider.showCircularProgress(false);
    DialogCircularBuilder(context).hideOpenDialog();
    Navigator.of(context).pop();
  }

  Widget ddItemFromFirebase() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
       readOnly: true,
        controller: _ddIemController,
        style: const TextStyle(color: Colors.black),
        decoration: const InputDecoration(
            contentPadding:
            EdgeInsets.symmetric(horizontal: 10),
            // labelText: 'Password',
            // labelStyle: TextStyle(color: Colors.white),
            icon: Icon(Icons.search, color: Colors.black),
            border: InputBorder.none),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please provide item.';
          }
          return null;
        },
      ),
    );
      /*
      TypeAheadFormField(
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
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
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
      onSuggestionSelected: (Defects? suggestion) {
        _ddIemController.text = suggestion!.itemName;
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

       */
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
                  duplicateImg.add(false);

                  Asset asset = images[index];
                  return Card(
                    elevation: 5.0,
                    child: Stack(
                      children: <Widget>[
                        InkWell(
                          onTap: ()async {
                            String? imageName = images[index].name;
                            String imageNameSuffixPro='';
                            String imageNameSuffix='';

                            String imageDir = await ImageUtility.getImageDirPath();
                            String editedFileName = '';
                            Uint8List? _imageBytesList;

                            print("duplicateImg[index] ${duplicateImg[index]}");
                            if(!duplicateImg[index]) {
                              try {
                                var foundProImgName = DefectImageData
                                    .allListImagesItem.where((element) =>
                                (element.oldImgName == imageName));
                                if (foundProImgName.isNotEmpty) {
                                  imageNameSuffix =
                                  '${foundProImgName.first.newImgName}';
                                  imageNameSuffixPro =
                                  '${foundProImgName.first.proImgName}';

                                  if (await File('$imageDir/$imageNameSuffix')
                                      .exists()) {
                                    _imageBytesList =
                                        File('$imageDir/$imageNameSuffix')
                                            .readAsBytesSync();
                                    editedFileName =
                                    '$imageDir/$imageNameSuffix';
                                  } else if (await File(
                                      '$imageDir/$imageNameSuffixPro')
                                      .exists()) {
                                    _imageBytesList =
                                        File('$imageDir/$imageNameSuffixPro')
                                            .readAsBytesSync();
                                    editedFileName =
                                    '$imageDir/$imageNameSuffixPro';
                                  }

                                  Uint8List decodedBytes = await ImageUtility
                                      .compressImageList(
                                      _imageBytesList!, 1200, 1600, 90);
                                  ui
                                      .Image _myBackgroundImage = await ImageUtility
                                      .loadImage(decodedBytes);

                                  final result = await Navigator.push(context,
                                      MaterialPageRoute(builder: (context) =>
                                          ImageDialogOld(
                                              backgroundImage: _myBackgroundImage,
                                              imageIndex: index,
                                              itemName: _ddIemController.text,
                                              editedName: editedFileName,
                                              oldName: '${foundProImgName.first
                                                  .oldImgName}'
                                          )));
                                  if (result != null) {
                                    setState(() => editedImage);
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Please save image before paint",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                }
                              } catch (e) {
                                print(e);
                              }
                            }else{
                              Fluttertoast.showToast(
                                  msg: "Duplicate picture cannot be edit!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 5,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            }
                          },
                          child: Container(
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
                                (DefectImageData.allListImagesItem[index].isImgEdited &&(images[index].name == DefectImageData.allListImagesItem[index].oldImgName))?
                                const DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                  ),
                                  child: Center(
                                    child: Text("Edited",style: TextStyle(backgroundColor: Colors.white))                            ,
                                  ),
                                ):Container(),
                                (duplicateImg[index])?
                                const DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                  ),
                                  child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text(" Duplicate found ",style: TextStyle(backgroundColor: Colors.redAccent, color: Colors.white))),
                                ):Container(),
                              ],
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
                            onTap: () async {
                              String? imageName = images[index].name;
                              String imageDir = await ImageUtility.getImageDirPath();

                              String imageNameSuffix = '';
                              String imageNameSuffixPro = '';

                              if(!duplicateImg[index]) {
                                var foundImgIndex = DefectImageData.allListImagesItem.indexWhere((element) => (element.oldImgName == imageName));
                                if (foundImgIndex >= 0) {
                                  imageNameSuffix = '${DefectImageData.allListImagesItem[foundImgIndex].newImgName}';
                                  imageNameSuffixPro = '${DefectImageData.allListImagesItem[foundImgIndex].proImgName}';

                                  if (await File('$imageDir/$imageNameSuffix').exists()) {
                                    await File('$imageDir/$imageNameSuffix').delete();
                                    DefectImageData.allListImagesItem.removeWhere((element) => (element.newImgName == imageNameSuffix));
                                    setState(() => deletedImage = true);

                                    try {
                                      Directory imageDir = await ImageUtility.getImageDir();
                                      List<FileSystemEntity> entries = imageDir.listSync(recursive: false).toList();
                                      int newCounter = 0;
                                      for (var i = 0; i < entries.length; i++) {
                                        var fileName = (entries[i].path.split('/').last);
                                        if ((fileName.split('_').first) == ddItemValue) {
                                          ++newCounter;
                                          String newName = "$ddItemValue\_$newCounter.jpg";
                                          File('$imageDir/$fileName').renameSync('$imageDir/$newName');
                                        }
                                      }
                                    } catch (e) {
                                      print(e);
                                    }
                                  } else if (await File('$imageDir/$imageNameSuffixPro').exists()) {
                                    await File('$imageDir/$imageNameSuffixPro').delete();
                                    DefectImageData.allListImagesItem.removeWhere((element) => (element.proImgName == imageNameSuffixPro));
                                    setState(() => deletedImage = true);
                                  }
                                }
                              }else{
                                setState(() => duplicateImg.removeAt(index));
                              }

                              if (deletedImage == true) {
                                Fluttertoast.showToast(
                                    msg: "Image Deleted",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              }
                              // else {
                              //   Fluttertoast.showToast(
                              //       msg: "Image can not Delete",
                              //       toastLength: Toast.LENGTH_SHORT,
                              //       gravity: ToastGravity.CENTER,
                              //       timeInSecForIosWeb: 1,
                              //       backgroundColor: Colors.red,
                              //       textColor: Colors.white,
                              //       fontSize: 16.0
                              //   );
                              // }
                              setState(() {
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