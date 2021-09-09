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