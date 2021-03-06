import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:chat_app/models/defect.dart';
import 'package:chat_app/models/list_image_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uri_to_file/uri_to_file.dart';

class ImageUtility {

  static Future<File> getImageFile(String filename) async {
    Uri _uri = Uri.parse(filename);
    File _file = await toFile(_uri);
    return _file;
  }
  static Future<Directory> getImageDir() async{
    final directory = await getExternalStorageDirectory();
    final myImagePath = '${directory?.path}/images';
    final myImgDir = await Directory(myImagePath).create();

    return myImgDir;
  }
  static Future<List<FileSystemEntity>> dirContents(Directory dir) {
    var files = <FileSystemEntity>[];
    var completer = Completer<List<FileSystemEntity>>();
    var lister = dir.list(recursive: false);
    lister.listen((file) => files.add(file),
        // should also register onError
        onDone: () => completer.complete(files));
    return completer.future;
  }
  static Future<String> getImageDirPath() async{
    final directory = await getExternalStorageDirectory();
    final myImagePath = '${directory?.path}/images';
    final myImgDir = await Directory(myImagePath).create();

    return myImagePath;
    // var dir = await getExternalStorageDirectory();
    // Directory testdir = await  Directory('${dir?.path}/images');
    // return testdir;
  }

  static Future<Uint8List> compressFile(File file, int width, int height, int rotation) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: width,
      minHeight: height,
      quality: 94,
      rotate: rotation,
    );
    return result!;
  }
  static Future<File> compressAndGetImageFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, targetPath,
      quality: 98,
      rotate: 0,
    );
    return result!;
  }
  static Future<Uint8List> compressImageList(Uint8List list, int width, int height, int rotation) async {
    var result = await FlutterImageCompress.compressWithList(
        list,
        minHeight: width,
        minWidth: height,
        quality: 98,
        rotate: rotation,
      );
    return result;
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

  static Future<bool> deleteFile(String imageNameSuffix) async {
    try {
      String imageDir = await getImageDirPath();
      if(await File('$imageDir/$imageNameSuffix').exists()){
        try{
          await File('$imageDir/$imageNameSuffix').delete();
          return true;
        }catch(e){
          return false;
        }
      }else{
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
  static Future<File> changeFileName(File file, String newFileName) {
    var path = file.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    return file.rename(newPath);
  }
  static Future<void> changeFileNameOnly(String fileName, String newFileName, var dpi) async{
    try {
      String imageDir = await getImageDirPath();

      await File('$imageDir/$fileName').exists().then((_) async {
        String newFilePath = '$imageDir/$newFileName';
        File('$imageDir/$fileName').renameSync(newFilePath);
        Uint8List decodedBytes = await compressFile(File('$imageDir/$newFileName'),1024,768,0);
        decodedBytes[13] = 1;
        decodedBytes[14] = (dpi >> 8);
        decodedBytes[15] = (dpi & 0xff);
        decodedBytes[16] = (dpi >> 8);
        decodedBytes[17] = (dpi & 0xff);

        File('$imageDir/$newFileName').writeAsBytesSync(decodedBytes);

        for (var element in DefectImageData.allListImagesItem) {
          if(element.newImgName == fileName){
            element.newImgName = newFileName;
          }
        }
      });
    }catch(e){
      print(e);
    }
  }


  static Future<void> createImage(String itemName, int fileName) async {
    try {
      String imageDir = await getImageDirPath();

      ui.PictureRecorder recorder = ui.PictureRecorder();
      Canvas c = Canvas(recorder);
      var rect = const Rect.fromLTWH(0.0, 0.0, 300.0, 300.0);
      c.clipRect(rect);

      final textStyle = const TextStyle(color: Colors.white, fontSize: 24);
      TextSpan textSpan = TextSpan(text: itemName,style: textStyle);
      TextPainter textPainter = TextPainter(text: textSpan,textDirection: TextDirection.ltr);
      textPainter.layout(minWidth: 0,maxWidth: 300);

      Offset offset = const Offset(10.0, 10.0);
      textPainter.paint(c, offset);

      // c.drawPaint(paint);
      ui.Picture picture = recorder.endRecording();
      ui.Image img = await picture.toImage(300, 300);

// print("img $img");
      ByteData? byteData = await img.toByteData(format: ui.ImageByteFormat.png);
// print("byteData $byteData");
      Uint8List jpgBytes = byteData!.buffer.asUint8List();
// print("jpgBytes $jpgBytes");
      File('$imageDir/$fileName\_0.jpg').create(recursive: true);
      File('$imageDir/$fileName\_0.jpg').writeAsBytesSync(jpgBytes);

    } catch (e) {
      print(e);
    }
  }

  static Future<bool> saveImage(File _imageFile, String imageName, String _itemName, String _newImageName, ui.Image _logoImage, int _itemValue) async {
    try {
      String imageDir = await getImageDirPath();
      // if((await File('$imageDir/$imageName').exists())||(await File('$imageDir/$imageNameSuffix').exists())){
      //   return false;
      // }else{
        Uint8List decodedBytes = await compressFile(_imageFile,1600,1200,0);
        ui.Image _imageBackground = await ImageUtility.loadImage(decodedBytes);
        await writeLogoInsideImage('$imageDir/$_newImageName', _imageBackground, _itemName, _logoImage);

        final listImagesItem = ListImagesItem(
            itemValue: _itemValue,
            oldImgName: imageName,
            oldImgUriFile: _imageFile,
            newImgName: _newImageName,
            newImgPath: '$imageDir/$_newImageName'
        );
        DefectImageData.addImageItem(listImagesItem);

        return true;
      // }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<void> writeLogoInsideImage(String imagePath, ui.Image backgroundImage, String itemName, ui.Image _logoImage) async{
    // print("Write logo : $itemName");
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas c = Canvas(recorder);

    paintImage(
      canvas: c,
      rect: Rect.fromLTWH(0, 0, backgroundImage.width.toDouble(), backgroundImage.height.toDouble()),
      image: backgroundImage,
      fit: BoxFit.fill,
      repeat: ImageRepeat.noRepeat,
      scale: 1.0,
      alignment: Alignment.center,
      flipHorizontally: false,
      filterQuality: FilterQuality.high,
      isAntiAlias: false,
    );

    // final ui.Image _logoImage = await ImageUtility.loadUiImage('assets/images/pqc.png');
    double positionX = (backgroundImage.width - _logoImage.width * 1.15).toDouble();
    double positionY = (backgroundImage.height - _logoImage.height * 1.15).toDouble();
    c.drawImage(_logoImage, Offset(positionX,positionY), Paint());

    const textStyle = TextStyle(backgroundColor: Colors.white, color: Colors.black, fontSize: 45);
    TextSpan textSpan = TextSpan(text: itemName,style: textStyle);
    TextPainter textPainter = TextPainter(text: textSpan,textDirection: TextDirection.ltr);
    textPainter.layout(minWidth: 0,maxWidth: backgroundImage.width.toDouble());

    double testPositionX = (backgroundImage.width - (backgroundImage.width - 24)).toDouble();
    double testPositionY = (backgroundImage.height - (backgroundImage.height - 8)).toDouble();
    textPainter.paint(c, Offset(testPositionX, testPositionY));

    ui.Picture picture = recorder.endRecording();

    final img = await picture.toImage(backgroundImage.width, backgroundImage.height);

    ByteData? byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    Uint8List newJpgBytes = await compressImageList(byteData!.buffer.asUint8List(),1600,1200,0);
    File(imagePath).writeAsBytesSync(newJpgBytes);
  }

  // static Future<void> writeLogoInsideImage(String imagePath,int width, int height, String itemName) async{
  //   ui.PictureRecorder recorder = ui.PictureRecorder();
  //   Canvas c = Canvas(recorder);
  //
  //   Uri _uriPicture = Uri.parse(imagePath);
  //   File _filePicture = await toFile(_uriPicture);
  //   final bytesPicture = _filePicture.readAsBytesSync();
  //   String img64Picture = base64Encode(bytesPicture);
  //   final decodedBytesPicture = base64Decode(img64Picture);
  //   ui.Image originalImage = await ImageUtility.loadImage(
  //       decodedBytesPicture);
  //   c.drawImage(originalImage, Offset.zero, Paint());
  //
  //   ui.Image _logoImage = await ImageUtility.loadUiImage('assets/images/pqc.png');
  //   double positionX = (originalImage.width - _logoImage.width * 1.15).toDouble();
  //   double positionY = (originalImage.height - _logoImage.height * 1.15).toDouble();
  //   c.drawImage(_logoImage, Offset(positionX,positionY), Paint());
  //
  //   // var rect = Rect.fromLTWH(50.0, 50.0, _width, _height);
  //   // c.clipRect(rect);
  //   const textStyle = TextStyle(backgroundColor: Colors.white, color: Colors.black, fontSize: 24);
  //   TextSpan textSpan = TextSpan(text: itemName,style: textStyle);
  //   TextPainter textPainter = TextPainter(text: textSpan,textDirection: TextDirection.ltr);
  //   textPainter.layout(minWidth: 0,maxWidth: originalImage.width.toDouble());
  //
  //   // print('width : ${originalImage.width}');
  //   // print('Height : ${originalImage.height}');
  //   double testPositionX = (originalImage.width - 60).toDouble();
  //   double testPositionY = (originalImage.height - (originalImage.height - 50)).toDouble();
  //   textPainter.paint(c, Offset(testPositionX, testPositionY));
  //
  //   ui.Picture picture = recorder.endRecording();
  //   ui.Image img = await picture.toImage(originalImage.width, originalImage.height);
  //
  //   ByteData? byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  //   Uint8List jpgBytes = byteData!.buffer.asUint8List();
  //   File(imagePath).writeAsBytesSync(jpgBytes);
  // }
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
