// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:chat_app/utils/image_dialog.dart';
// import 'package:chat_app/utils/image_full_screen_wrapper.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:multi_image_picker2/multi_image_picker2.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:uri_to_file/uri_to_file.dart';
// import 'dart:ui' as ui;
// import 'package:image/image.dart' as IMG;
//
// class TeameLeaderPage extends StatefulWidget {
//   //const AdminHomePage({Key? key}) : super(key: key);
//   static const String routeName = "\team_leader";
//
//   @override
//   _TeameLeaderPageState createState() => _TeameLeaderPageState();
// }
// /*
// class CounterStorage {
//   Future<String> get _localPath async {
//     final directory = await getApplicationDocumentsDirectory();
//
//     return directory.path;
//   }
//
//   Future<File> get _localFile({required String fileLocation}) async {
//     final path = await _localPath;
//     return File('$path/counter.txt');
//   }
//
//   Future<int> readCounter() async {
//     try {
//       final file = await _localFile;
//
//       // Read the file
//       final contents = await file.readAsString();
//
//       return int.parse(contents);
//     } catch (e) {
//       // If encountering an error, return 0
//       return 0;
//     }
//   }
//
//   Future<File> writeCounter(int counter) async {
//     final file = await _localFile;
//
//     // Write the file
//     return file.writeAsString('$counter');
//   }
// }
// */
// class _TeameLeaderPageState extends State<TeameLeaderPage> {
//   List<Asset> images = <Asset>[];
//   //List<File>files = <File>[];
//   File? _file;
//   String _error = 'No Error Detected Test';
//   //late final CounterStorage storage;
//
//   late Uint8List _imageByteslist;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//   Future<String> _getDirectoryPath() async{
//     final directory = await getExternalStorageDirectory();
//     final myImagePath = '${directory?.path}/MyImages';
//     final myImgDir = await Directory(myImagePath).create();
//
//     return myImagePath;
//   }
//
//   Future<ui.Image> loadImage(Uint8List bytes) async {
//     final Completer<ui.Image> completer = Completer();
//     ui.decodeImageFromList(bytes, (ui.Image img) => completer.complete(img));
//     return completer.future;
//   }
//   Future<ui.Image> resizeImage(Uint8List data) async {
//     Uint8List? resizedData = data;
//     IMG.Image? img = IMG.decodeImage(data);
//     IMG.Image resized = IMG.copyResize(img!, width: 325, height: 265);
//     resizedData = IMG.encodeJpg(resized) as Uint8List?;
//
//     final Completer<ui.Image> completer = Completer();
//     ui.decodeImageFromList(resizedData!, (ui.Image img) => completer.complete(img));
//     return completer.future;
//   }
//
//   Widget buildGridView() {
//     return ListView(
//       shrinkWrap: true,
//       physics: const ScrollPhysics(),
//       children: <Widget>[
//         const SizedBox(height: 10.0),
//         ListView.builder(
//           shrinkWrap: true,
//           itemCount: 1,
//           physics: const ScrollPhysics(),
//           itemBuilder: (context, index) {
//             return Column(
//               children: <Widget>[
//                 Container(
//                   height: 50.0,
//                   color: Colors.green,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: const <Widget>[
//                       Icon(Icons.format_list_numbered,
//                           color: Colors.white),
//                       Padding(
//                           padding: EdgeInsets.only(right: 5.0)),
//                       Text('List Item',
//                           style: TextStyle(
//                               fontSize: 20.0, color: Colors.white)),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 150.0,
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     scrollDirection: Axis.horizontal,
//                     itemCount: images.length,
//                     itemBuilder: (context, index) {
//                       Asset asset = images[index];
//                       //print("name ${asset.name}");
//                       //print("identifier ${asset.identifier}");
//                       return Card(
//                         elevation: 5.0,
//                         child: InkWell(
//                           onTap: ()async {
//                             String? imageName = images[index].name;
//                             String? imageUri = images[index].identifier;
//                             Uri? _uri = Uri.parse(imageUri!);
//                             //print("Uri - $_uri");
//                             _file = await toFile(_uri);
//
//                             final myImagePath = _getDirectoryPath();
//                             //var kompresimg = File("$myImagePath/$imageName")
//                             //  ..writeAsBytesSync(_file!.encodeJpg(gambarKecilx, quality: 95));
//
//                             await _file!.copy("$myImagePath/$imageName");
//
//                             //File imageFile = File.fromUri(_uri);
//                             //print("File - $_file");
//                             Uint8List _imageByteslist = await _file!.readAsBytes();
//                             //print("ImageByteslist - $_imageByteslist");
//                             //await _file!.readAsBytes().then((value){
//                               //_imageByteslist = Uint8List.fromList(value);
//                               //print("ImageByteslist - $_imageByteslist");
//                             //}).catchError((onError){
//                             //  print('Exception error reading image file ' + onError.toString());
//                             //});
//
//                             try{
//                               final ui.Image _myBackgroundImage;
//                               _myBackgroundImage = await loadImage(_imageByteslist);
//                               //print("MyBackgroundImage - $_myBackgroundImage");
//                               Navigator.push(context,
//                                   MaterialPageRoute(builder: (context) => ImageDialogOld(
//                                     myBackgroundImage: _myBackgroundImage,
//                                     //imageUri: _file,
//                                     imageUri: imageUri,
//                                     tag: "generate_a_unique_tag",
//                                   ),
//                                 )
//                               );
//                             } catch (e) {
//                               print(e);
//                             }
//                           },
//                           child: Container(
//                             height: MediaQuery.of(context).size.width / 3,
//                             width: MediaQuery.of(context).size.width / 3,
//                             alignment: Alignment.center,
//                             child: AssetThumb(
//                               asset: asset,
//                               width: 300,
//                               height: 300,
//                               quality: 75,
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 10.0),
//               ],
//             );
//           },
//         ),
//       ],
//     );
//   }
//
//   Future<void> loadAssets() async {
//     List<Asset> resultList = <Asset>[];
//     String error = 'No Error Detected';
//
//     try {
//       resultList = await MultiImagePicker.pickImages(
//         maxImages: 300,
//         enableCamera: true,
//         selectedAssets: images,
//         cupertinoOptions: CupertinoOptions(
//           takePhotoIcon: "chat",
//           doneButtonTitle: "Fatto",
//         ),
//         materialOptions: MaterialOptions(
//           actionBarColor: "#abcdef",
//           actionBarTitle: "Example App",
//           allViewTitle: "All Photos",
//           useDetailsView: false,
//           selectCircleStrokeColor: "#000000",
//         ),
//       );
//     } on Exception catch (e) {
//       error = e.toString();
//     }
//     if (!mounted) return;
//
//     setState(() {
//       images = resultList;
//       _error = error;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print("TeamLeader>>");
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text('TEAM LEADER',
//               style: TextStyle(color: Colors.white, fontSize: 13)),
//           Center(child: Text('Error: $_error')),
//           ElevatedButton(
//             child: const Text("Pick images"),
//             onPressed: loadAssets,
//           ),
//           Expanded(
//             child: buildGridView(),
//           )
//         ],
//       ),
//     );
//   }
// }
