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

  File? _file;

  String ddItemValue = '';
  String ddItem = '';
  List<Asset> images = <Asset>[];
  List<int> editedImage = [];

  late ListProvider _defectProvider;
  final TextEditingController _ddIemController = TextEditingController();


  @override
  void initState() {
    super.initState();
    // print("Edit List Item Dialog Widget");
    _ddIemController.text = widget.listItem.item!;
    images = widget.listItem.images;
    ddItem = widget.listItem.item!;
    ddItemValue = widget.listItem.itemValue!;
    editedImage = widget.listItem.edited;
  }

  @override
  void didChangeDependencies() {;
    super.didChangeDependencies();
    _defectProvider = Provider.of<ListProvider>(context,listen: false);
    if (images.isEmpty) {
      print("edit page >> ${widget.listItem}");
      _defectProvider.deleteItem(widget.listItem);
    }
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
    DialogCircularBuilder(context).showLoadingIndicator(
        value: _defectProvider.circularIndicator, text: '');
    // print("show circular : ${_defectProvider.circularIndicator}");

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      int counter =0;
      for (int i = 0; i < images.length; i++) {
        ++counter;
        String? imageUri = images[i].identifier;
        String? imageName = images[i].name;
        String? itemName = "$ddItem\nNo-$counter";
        await ImageUtility.saveImage(imageUri!, imageName!,itemName);
      }
      Fluttertoast.showToast(
          msg: "Updated Item",
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
        edited: editedImage,
        //description: description,
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
                  Asset asset = images[index];
                  //print("name ${asset.name}");
                  //print("identifier ${asset.identifier}");
                  print("List edit item : $editedImage");
                  return Card(
                    //clipBehavior: Clip.antiAlias,
                    elevation: 5.0,
                    child: Stack(
                      children: <Widget>[
                        InkWell(
                          onTap: ()async {
                            String? imageName = images[index].name;
                            String? imageUri = images[index].identifier;
                            // Uri? _uri = Uri.parse(imageUri!);
                            // //print("Uri - $_uri");
                            // _file = await toFile(_uri);

                            //final myImagePath = _getDirectoryPath();
                            //var kompresimg = File("$myImagePath/$imageName")
                            //  ..writeAsBytesSync(_file!.encodeJpg(gambarKecilx, quality: 95));

                            //await _file!.copy("$myImagePath/$imageName");

                            //File imageFile = File.fromUri(_uri);
                            //print("File - $_file");
                            // Uint8List _imageByteslist = await _file!.readAsBytes();
                            //print("ImageByteslist - $_imageByteslist");
                            //await _file!.readAsBytes().then((value){
                            //_imageByteslist = Uint8List.fromList(value);
                            //print("ImageByteslist - $_imageByteslist");
                            //}).catchError((onError){
                            //  print('Exception error reading image file ' + onError.toString());
                            //});

                            try{
                              // Uri _uri = Uri.parse(imageUri!);
                              // File _fileBackgroundImage = await toFile(_uri);
                              // Uint8List _imageByteslist = await _fileBackgroundImage.readAsBytes();

                              var dir = await getExternalStorageDirectory();
                              var testdir = await Directory('${dir?.path}/images').create(recursive: true);

                              if(await File('${testdir.path}/$imageName').exists()){
                                Uint8List _imageBytesList = File('${testdir.path}/$imageName').readAsBytesSync();
                                Uint8List decodedBytes = await ImageUtility.comporessImageList(_imageBytesList);
                                ui.Image _myBackgroundImage = await ImageUtility.loadImage(decodedBytes);

                                final result = await Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => ImageDialogOld(
                                      backgroundImage: _myBackgroundImage,
                                      //imageUri: _file,
                                      imageUri: imageUri!,
                                      imageName: imageName!,
                                      imageIndex: index,
                                      itemName: _ddIemController.text,
                                    ),
                                    )
                                );
                                if(result!=null){
                                  editedImage.add(result);
                                  setState((){
                                    editedImage = Set.of(editedImage).toList();
                                  });
                                }
                              }else{
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
                              if(await ImageUtility.deleteFile(images[index].name) == true){

                                Fluttertoast.showToast(
                                    msg: "Image Deleted",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                                editedImage.remove(index);
                              }else{
                                Fluttertoast.showToast(
                                    msg: "Image can not Delete",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              }
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