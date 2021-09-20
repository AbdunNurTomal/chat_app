import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/services.dart' show rootBundle;
import 'package:uri_to_file/uri_to_file.dart';

class ImageUtility {

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

  // Future<void> watermarkPicture( String picture, String watermark, String fileName) async {
  //   Uri _uriPicture = Uri.parse(picture);
  //   File _filePicture = await toFile(_uriPicture);
  //   Uri _uriWatermark = Uri.parse(watermark);
  //   File _fileWatermark = await toFile(_uriWatermark);
  //
  //   try {
  //     ui.PictureRecorder recorder = ui.PictureRecorder();
  //     ui.Canvas c = ui.Canvas(recorder);
  //     //var rect = Rect.fromLTWH(0.0, 0.0, _width, _height);
  //     //c.clipRect(rect);
  //
  //     final bytesPicture = _filePicture.readAsBytesSync();
  //     String img64Picture = base64Encode(bytesPicture);
  //     final decodedBytesPicture = base64Decode(img64Picture);
  //     final ui.Image originalImage = await ImageUtility.loadImage(
  //         decodedBytesPicture);
  //
  //     final bytesWatermark = _fileWatermark.readAsBytesSync();
  //     String img64Watermark = base64Encode(bytesWatermark);
  //     final decodedBytesWatermark = base64Decode(img64Watermark);
  //     final ui.Image watermarkImage = await ImageUtility.loadImage(
  //         decodedBytesWatermark);
  //
  //     Paint
  //     final mergedImage = c.Image(originalImage.width + watermarkImage.width, max(originalImage.height, watermarkImage.height));
  //     ui.copyInto(mergedImage, originalImage, blend = false);
  //     ui.copyInto(mergedImage, watermarkImage, dstx = originalImage.width, blend = false);
  //
  //     final documentDirectory = await getApplicationDocumentsDirectory();
  //     final file = new File(join(documentDirectory.path, "merged_image.jpg"));
  //     file.writeAsBytesSync(encodeJpg(mergedImage));
  //
  //     c.drawImage(originalImage, watermarkImage);
  //
  //     // Easy customisation for the position of the watermark in the next two lines
  //     final int positionX = (originalImage.width / 2 - watermarkImage.width / 2)
  //         .toInt();
  //     final int positionY = (originalImage.height -
  //         watermarkImage.height * 1.15).toInt();
  //
  //     ui.copyInto(
  //       originalImage,
  //       image,
  //       dstX: positionX,
  //       dstY: positionY,
  //     );
  //
  //     final File watermarkedFile = File(watermark);
  //     await watermarkedFile.writeAsBytes(ui.encodeJpg(originalImage));
  //
  //   }catch (e) {
  //     print(e);
  //   }
  //
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
