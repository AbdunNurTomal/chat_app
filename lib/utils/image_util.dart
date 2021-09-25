import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uri_to_file/uri_to_file.dart';

class ImageUtility {

  static Future<File> getImageFile(String filename) async {
    Uri _uri = Uri.parse(filename);
    File _file = await toFile(_uri);
    return _file;
  }

  static Future<Directory> getImageDirPath() async{
    var dir = await getExternalStorageDirectory();
    Directory testdir = await  Directory('${dir?.path}/images');

    return testdir;
  }

  static Future<ui.Image> loadImage(Uint8List bytes) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(bytes, (ui.Image img) => completer.complete(img));
    return completer.future;
  }

  static Future<ui.Image> loadUiImage(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final list = Uint8List.view(data.buffer);
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(list, completer.complete);
    return completer.future;
  }
  static Future<bool> deleteFile(String? fileName) async {
    try {
      var dir = await getExternalStorageDirectory();
      var testdir = await Directory('${dir?.path}/images');

      if(fileName != null) {
        await File('${testdir.path}/$fileName').delete();
        return true;
      }else{
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<void> changeFileNameOnly(String fileName, String newFileName) async{
    try {
      var dir = await getExternalStorageDirectory();
      var testdir = await Directory('${dir?.path}/images');

      await File('${testdir.path}/$fileName').exists().then((_) async {
        String newFilePath = '${testdir.path}/$newFileName';
        await File('${testdir.path}/$fileName').renameSync(newFilePath);
      });
    }catch(e){
      print(e);
    }
  }
  static Future<void> createImage(String itemName, int fileName) async {
    try {
      var dir = await getExternalStorageDirectory();

      ui.PictureRecorder recorder = ui.PictureRecorder();
      Canvas c = Canvas(recorder);
      var rect = Rect.fromLTWH(0.0, 0.0, 300.0, 300.0);
      c.clipRect(rect);

      final textStyle = TextStyle(color: Colors.white, fontSize: 24);
      TextSpan textSpan = TextSpan(text: itemName,style: textStyle);
      TextPainter textPainter = TextPainter(text: textSpan,textDirection: TextDirection.ltr);
      textPainter.layout(minWidth: 0,maxWidth: 300);

      Offset offset = Offset(10.0, 10.0);
      textPainter.paint(c, offset);

      // c.drawPaint(paint);
      ui.Picture picture = recorder.endRecording();
      ui.Image img = await picture.toImage(300, 300);

// print("img $img");
      ByteData? byteData = await img.toByteData(format: ui.ImageByteFormat.png);
// print("byteData $byteData");
      Uint8List jpgBytes = byteData!.buffer.asUint8List();
// print("jpgBytes $jpgBytes");
      var testdir = await Directory('${dir?.path}/images').create(recursive: true);
      File('${testdir.path}/$fileName\_0.jpg').create(recursive: true);

      File('${testdir.path}/$fileName\_0.jpg').writeAsBytesSync(jpgBytes);

    } catch (e) {
      print(e);
    }
  }

  static Future<bool> saveImage(String file, String fileName) async {
    try {
      // String fileName = '$itemNumber\_$slNo.jpg';
      // String itemName = '$itemNumber\_$slNo';

      Uri _uri = Uri.parse(file);
      File _file = await toFile(_uri);

      var dir = await getExternalStorageDirectory();
      var testdir = await Directory('${dir?.path}/images').create(recursive: true);

      final bytes = _file.readAsBytesSync();
      String img64 = base64Encode(bytes);
      File('${testdir.path}/$fileName').create(recursive: true);
      File('${testdir.path}/$fileName').exists().then((_) { return false;});
      final decodedBytes = base64Decode(img64);

      File('${testdir.path}/$fileName').writeAsBytesSync(decodedBytes);

      ui.Image _imageBackgroud = await ImageUtility.loadImage(decodedBytes);
      writeLogoInsideImage('${testdir.path}/$fileName',_imageBackgroud.width,_imageBackgroud.height,fileName);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<void> writeLogoInsideImage(String imagePath,int width, int height, String itemName) async{
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas c = Canvas(recorder);

    Uri _uriPicture = Uri.parse(imagePath);
    File _filePicture = await toFile(_uriPicture);
    final bytesPicture = _filePicture.readAsBytesSync();
    String img64Picture = base64Encode(bytesPicture);
    final decodedBytesPicture = base64Decode(img64Picture);
    ui.Image originalImage = await ImageUtility.loadImage(
        decodedBytesPicture);
    c.drawImage(originalImage, Offset.zero, Paint());

    ui.Image _logoImage = await ImageUtility.loadUiImage('assets/images/pqc.png');
    double positionX = (originalImage.width - _logoImage.width * 1.15).toDouble();
    double positionY = (originalImage.height - _logoImage.height * 1.15).toDouble();
    c.drawImage(_logoImage, Offset(positionX,positionY), Paint());

    // var rect = Rect.fromLTWH(50.0, 50.0, _width, _height);
    // c.clipRect(rect);
    const textStyle = TextStyle(backgroundColor: Colors.white, color: Colors.black, fontSize: 24);
    TextSpan textSpan = TextSpan(text: itemName,style: textStyle);
    TextPainter textPainter = TextPainter(text: textSpan,textDirection: TextDirection.ltr);
    textPainter.layout(minWidth: 0,maxWidth: originalImage.width.toDouble());

    // print('width : ${originalImage.width}');
    // print('Height : ${originalImage.height}');
    double testPositionX = (originalImage.width - 60).toDouble();
    double testPositionY = (originalImage.height - (originalImage.height - 50)).toDouble();
    textPainter.paint(c, Offset(testPositionX, testPositionY));

    ui.Picture picture = recorder.endRecording();
    ui.Image img = await picture.toImage(originalImage.width, originalImage.height);

    ByteData? byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    Uint8List jpgBytes = byteData!.buffer.asUint8List();
    File(imagePath).writeAsBytesSync(jpgBytes);
  }

  Future<String> _getDirectoryPath() async{
    final directory = await getExternalStorageDirectory();
    final myImagePath = '${directory?.path}/MyImages';
    final myImgDir = await Directory(myImagePath).create();

    return myImagePath;
  }
  // Future<void> _capturePng() async {
  //   RenderRepaintBoundary boundary = globalKey.currentContext
  //       ?.findRenderObject() as RenderRepaintBoundary;
  //   ui.Image image = await boundary.toImage();
  //   ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //   Uint8List pngBytes = byteData!.buffer.asUint8List();
  //   //print(pngBytes);
  // }
}
/*
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class ConvertWidgetToImage {
  Future<Uint8List> execute(GlobalKey widgetGlobalKey) async {
    RenderObject? boundary = widgetGlobalKey.currentContext?.findRenderObject();
    ui.Image image = await boundary!.toImage();

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    final logoImage = await loadLocalImage();

    ImagePainter(image, logo: logoImage)..paint(canvas, Size.infinite);

    final ui.Image renderImage = await recorder.endRecording().toImage(
      image.width, image.height + logoImage.height,
    );
    ByteData byteData = renderImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData.buffer.asUint8List();
  }

  Future<ui.Image> loadLocalImage() async {
    Completer<ImageInfo> completer = Completer();

    AssetImage('assets/logo.png').resolve(ImageConfiguration()).addListener(
      (ImageStreamListener((ImageInfo info, bool _) => completer.complete(info))),
    );
    ImageInfo imageInfo = await completer.future;
    return imageInfo.image;
  }
}
class ImagePainter extends CustomPainter {
  final ui.Image image;

  final ui.Image logo;

  ImagePainter(
      this.image, {
        this.logo,
      });

  @override
  void paint(Canvas canvas, Size size) {

    canvas.drawImage(image, Offset(0, 0), Paint());

    if (logo != null) {
      canvas.drawImage(
          logo,
          Offset(image.width.toDouble() - logo.width.toDouble(),
              image.height.toDouble() - logo.height.toDouble()),
          Paint());
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
*/
