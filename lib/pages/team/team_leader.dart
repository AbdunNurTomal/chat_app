import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:chat_app/models/defect.dart';
import 'package:chat_app/pages/report/add_list_item_dialog_widget.dart';
import 'package:chat_app/pages/report/list_item_widget.dart';
import 'package:chat_app/provider/list_provider.dart';
import 'package:chat_app/utils/global_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as IMG;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:chat_app/pages/report/process_image_report.dart';
import 'package:uri_to_file/uri_to_file.dart';
import 'package:chat_app/utils/image_util.dart';

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
  late ListProvider allItem;

  late final List<DownloadController> _downloadControllers;
  late ListProvider taskItems;

  @override
  void initState() {
    DefectData.callDefect();
    _downloadControllers = List<DownloadController>.generate(
        2, (index) => SimulatedDownloadController(onOpenDownload: () {
        _openDownload(index);
      }),
    );
    super.initState();
  }

  void _openDownload(int index) {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Open App ${index + 1}'),
    //   ),
    // );
  }

  void _showProcessDialog(context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(8.0),
          title: const Center(child: Text('Precess Report File')),
          content: Container(
            width: MediaQuery.of(context).size.width*0.8,
            height: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                StepProgressIndicator(
                  totalSteps: 6,
                  currentStep: 4,
                  size: 36,
                  selectedColor: Colors.black,
                  unselectedColor: Colors.grey,
                  customStep: (index, color, _) => color == Colors.black
                      ? Container(
                    color: color,
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  )
                      : Container(
                    color: color,
                    child: const Icon(
                      Icons.remove,
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Icon(Icons.picture_as_pdf_sharp),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(' Create a Pdf report'),
                    ),
                    SizedBox(
                      width: 96.0,
                      child: AnimatedBuilder(
                        animation: _downloadControllers[0],
                        builder: (context, child) {
                          return DownloadButton(
                            status: _downloadControllers[0].downloadStatus,
                            downloadProgress: _downloadControllers[0].progress,
                            onDownload: _downloadControllers[0].startDownload,
                            onCancel: _downloadControllers[0].stopDownload,
                            onOpen: _downloadControllers[0].openDownload,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Icon(Icons.video_collection_sharp),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(' Create a Video report'),
                    ),
                    SizedBox(
                      width: 96.0,
                      child: AnimatedBuilder(
                        animation: _downloadControllers[1],
                        builder: (context, child) {
                          return DownloadButton(
                            status: _downloadControllers[1].downloadStatus,
                            downloadProgress: _downloadControllers[1].progress,
                            onDownload: _downloadControllers[1].startDownload,
                            onCancel: _downloadControllers[1].stopDownload,
                            onOpen: _downloadControllers[1].openDownload,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40.0),
                InkWell(
                  child: Container(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(32)),
                      // borderRadius: BorderRadius.only(
                      //   bottomLeft: Radius.circular(32.0),
                      //   bottomRight: Radius.circular(32.0)
                      // ),
                    ),
                    child: const Text(
                      "Done",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // Row(
                //   children: const <Widget>[
                //     Icon(Icons.toys),
                //     Padding(
                //       padding: EdgeInsets.only(left: 8.0),
                //       child: Text('Third Item'),
                //     ),
                //   ],
                // ),
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
            PopupMenuButton<String>(
              elevation: 20,
              enabled: true,
              onSelected: (value) {
                //setState(() {
                //  _value = value;
                //});
                switch(value){
                  case 'Process':
                    allItem = Provider.of<ListProvider>(context,listen: false);
                    //print("Item <<>> ${allItem.allListItem[0].images[0].identifier}");
                    int countItem=0;
                    for(int i=0;i<allItem.allListItem.length;i++){
                      countItem++;
                      int countImage=0;
                      String item = '';
                      //String itemValue = allItem.allListItem[i].itemValue!;
                      if(allItem.allListItem[i].images.isNotEmpty){
                        item = '"${allItem.allListItem[i].item!}" \n ${allItem.allListItem[i].images.length} pictures';
                        ImageUtility.createImage(item,countItem);
                        for(int j=0;j<allItem.allListItem[i].images.length;j++){
                          countImage++;
                          String? imageName = allItem.allListItem[i].images[j].name;
                          // String? imageUri = allItem.allListItem[i].images[j].identifier;
                          String newImageName = '$countItem\_$countImage.jpg';
                          ImageUtility.changeFileNameOnly(imageName!,newImageName);
                          // ImageUtility.saveImage(imageUri!,countItem,countImage);
                        }
                      }
                    }
                    (allItem.allListItem.isNotEmpty) ? _showProcessDialog(context) : GlobalMethod.showAlertDialog(context,"Report Process Operation","No item found!!!");
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
        body:  Container(
            //margin: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
                //border: Border.all(
                //  color: Colors.black12,
                //  width: 3,
                //),
                //borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),

            // showAlertDialog(context),
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

enum DownloadStatus {
  notDownloaded,
  fetchingDownload,
  downloading,
  downloaded,
}

abstract class DownloadController implements ChangeNotifier {
  DownloadStatus get downloadStatus;
  double get progress;

  void startDownload();
  void stopDownload();
  void openDownload();
}

class SimulatedDownloadController extends DownloadController
    with ChangeNotifier {
  SimulatedDownloadController({
    DownloadStatus downloadStatus = DownloadStatus.notDownloaded,
    double progress = 0.0,
    required VoidCallback onOpenDownload,
  })   : _downloadStatus = downloadStatus,
        _progress = progress,
        _onOpenDownload = onOpenDownload;

  DownloadStatus _downloadStatus;
  @override
  DownloadStatus get downloadStatus => _downloadStatus;

  double _progress;
  @override
  double get progress => _progress;

  final VoidCallback _onOpenDownload;

  bool _isDownloading = false;

  @override
  void startDownload() {
    if (downloadStatus == DownloadStatus.notDownloaded) {
      _doSimulatedDownload();
    }
  }

  @override
  void stopDownload() {
    if (_isDownloading) {
      _isDownloading = false;
      _downloadStatus = DownloadStatus.notDownloaded;
      _progress = 0.0;
      notifyListeners();
    }
  }

  @override
  void openDownload() {
    if (downloadStatus == DownloadStatus.downloaded) {
      _onOpenDownload();
    }
  }

  Future<void> _doSimulatedDownload() async {
    _isDownloading = true;
    _downloadStatus = DownloadStatus.fetchingDownload;
    notifyListeners();

    // Wait a second to simulate fetch time.
    await Future<void>.delayed(const Duration(seconds: 1));

    // If the user chose to cancel the download, stop the simulation.
    if (!_isDownloading) {
      return;
    }

    // Shift to the downloading phase.
    _downloadStatus = DownloadStatus.downloading;
    notifyListeners();

    const downloadProgressStops = [0.0, 0.15, 0.45, 0.80, 1.0];
    for (final stop in downloadProgressStops) {
      // Wait a second to simulate varying download speeds.
      await Future<void>.delayed(const Duration(seconds: 1));

      // If the user chose to cancel the download, stop the simulation.
      if (!_isDownloading) {
        return;
      }

      // Update the download progress.
      _progress = stop;
      notifyListeners();
    }

    // Wait a second to simulate a final delay.
    await Future<void>.delayed(const Duration(seconds: 1));

    // If the user chose to cancel the download, stop the simulation.
    if (!_isDownloading) {
      return;
    }

    // Shift to the downloaded state, completing the simulation.
    _downloadStatus = DownloadStatus.downloaded;
    _isDownloading = false;
    notifyListeners();
  }
}

@immutable
class DownloadButton extends StatelessWidget {
  const DownloadButton({
    Key? key,
    required this.status,
    this.downloadProgress = 0.0,
    required this.onDownload,
    required this.onCancel,
    required this.onOpen,
    this.transitionDuration = const Duration(milliseconds: 500),
  }) : super(key: key);

  final DownloadStatus status;
  final double downloadProgress;
  final VoidCallback onDownload;
  final VoidCallback onCancel;
  final VoidCallback onOpen;
  final Duration transitionDuration;

  bool get _isDownloading => status == DownloadStatus.downloading;

  bool get _isFetching => status == DownloadStatus.fetchingDownload;

  bool get _isDownloaded => status == DownloadStatus.downloaded;

  void _onPressed() {
    switch (status) {
      case DownloadStatus.notDownloaded:
        onDownload();
        break;
      case DownloadStatus.fetchingDownload:
      // do nothing.
        break;
      case DownloadStatus.downloading:
        onCancel();
        break;
      case DownloadStatus.downloaded:
        onOpen();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressed,
      child: Stack(
        children: [
          _buildButtonShape(
            child: _buildText(context),
          ),
          _buildDownloadingProgress(),
        ],
      ),
    );
  }

  Widget _buildButtonShape({required Widget child}) {
    return AnimatedContainer(
      duration: transitionDuration,
      curve: Curves.ease,
      width: double.infinity,
      decoration: _isFetching
          ? ShapeDecoration(
        shape: const CircleBorder(),
        color: Colors.white.withOpacity(0.0),
      )
          : const ShapeDecoration(
        shape: StadiumBorder(),
        color: CupertinoColors.lightBackgroundGray,
      ),
      child: child,
    );
  }

  Widget _buildText(BuildContext context) {
    final text = _isDownloaded ? 'OPEN' : 'GET';
    final opacity = _isFetching ? 0.0 : 1.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: AnimatedOpacity(
        duration: transitionDuration,
        opacity: opacity,
        curve: Curves.ease,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.button?.copyWith(
            fontWeight: FontWeight.bold,
            color: CupertinoColors.activeBlue,
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadingProgress() {
    return Positioned.fill(
      child: AnimatedOpacity(
        duration: transitionDuration,
        opacity: _isFetching ? 1.0 : 0.0,
        curve: Curves.ease,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildProgressIndicator(),
            if (_isDownloading)
              const Icon(
                Icons.stop,
                size: 14.0,
                color: CupertinoColors.activeBlue,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return AspectRatio(
      aspectRatio: 1.0,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: downloadProgress),
        duration: const Duration(milliseconds: 200),
        builder: (context, progress, child) {
          return CircularProgressIndicator(
            backgroundColor: _isDownloading
                ? CupertinoColors.lightBackgroundGray
                : Colors.white.withOpacity(0.0),
            valueColor: AlwaysStoppedAnimation(_isFetching
                ? CupertinoColors.lightBackgroundGray
                : CupertinoColors.activeBlue),
            strokeWidth: 2.0,
            value: _isFetching ? null : progress,
          );
        },
      ),
    );
  }
}