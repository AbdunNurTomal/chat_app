import 'dart:ui' as ui;
import 'package:arrow_path/arrow_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef ImageSaveCallback = void Function(ui.Picture picture);

class PainterCanvas extends CustomPainter {
  ui.Image image;

  List<PaintedPoints> pointsList;

  List<PaintedArrow> arrowList;
  PaintedArrow unfinishedArrow;

  List<PaintedSquires> squaresList;
  PaintedSquires unfinishedSquare;

  List<PaintedCircles> circlesList;
  PaintedCircles unfinishedCircle;

  ImageSaveCallback saveCallback;
  bool saveImage;

  double width;
  double height;

  PainterCanvas({required this.image,
        required this.width,
        required this.height,
        required this.pointsList,
        required this.arrowList,
        required this.unfinishedArrow,
        required this.squaresList,
        required this.unfinishedSquare,
        required this.circlesList,
        required this.unfinishedCircle,
        required this.saveImage,
        required this.saveCallback});

  List<Offset> offsetPoints = [];

  @override
  void paint(Canvas canvas, Size size) {
    final recorder = ui.PictureRecorder();
    if (saveImage) {
      canvas = Canvas(recorder);
      var dpr = ui.window.devicePixelRatio;
      canvas.scale(dpr, dpr);
    }
    paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(0, 0, size.width, size.height),
        image: image,
        fit: BoxFit.contain,
        repeat: ImageRepeat.noRepeat,
        // scale: 1.0,
        alignment: Alignment.center,
        flipHorizontally: false,
        filterQuality: FilterQuality.high,
        isAntiAlias: false,
    );

    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(pointsList[i].points, pointsList[i + 1].points, pointsList[i].paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].points);
        offsetPoints.add(Offset(pointsList[i].points.dx + 0.1, pointsList[i].points.dy + 0.1));
        canvas.drawPoints(ui.PointMode.points, offsetPoints, pointsList[i].paint);
      }
    }

    Path path = Path();
    for (var i = 0; i < arrowList.length; i++) {
      path.moveTo(arrowList[i].end.dx, arrowList[i].end.dx);
      // path.relativeCubicTo(0, 0, size.width * 0.25, 50, size.width * 0.5, 0);
      path = ArrowPath.make(path: path);

      arrowList[i].paint.style = PaintingStyle.stroke;
      canvas.drawPath(path, arrowList[i].paint);

    }

    for (var i = 0; i < squaresList.length; i++) {
      squaresList[i].paint.style = PaintingStyle.stroke;
      final rect = Rect.fromPoints(squaresList[i].start, squaresList[i].end);
      canvas.drawRect(rect, squaresList[i].paint);
    }

    for (var i = 0; i < circlesList.length; i++) {
      circlesList[i].paint.style = PaintingStyle.stroke;
      double radius = (circlesList[i].end.dx - circlesList[i].start.dx) / 2;
      canvas.drawCircle(circlesList[i].start, radius, circlesList[i].paint);
    }

    unfinishedArrow.paint.style = PaintingStyle.stroke;
    // Path path = Path();
    if (unfinishedArrow.start.dx > unfinishedArrow.end.dx) {
      path.moveTo(unfinishedArrow.start.dx, unfinishedArrow.end.dx);
      path = ArrowPath.make(path: path);
    }
    canvas.drawPath(path, unfinishedArrow.paint);

    unfinishedSquare.paint.style = PaintingStyle.stroke;
    final rect = Rect.fromPoints(unfinishedSquare.start, unfinishedSquare.end);
    canvas.drawRect(rect, unfinishedSquare.paint);

    unfinishedCircle.paint.style = PaintingStyle.stroke;
    double radius = 0;
    if (unfinishedCircle.start.dx > unfinishedCircle.end.dx) {
      radius = (unfinishedCircle.start.dx - unfinishedCircle.end.dx) / 2;
    } else {
      radius = (unfinishedCircle.end.dx - unfinishedCircle.start.dx) / 2;
    }
    canvas.drawCircle(unfinishedCircle.start, radius, unfinishedCircle.paint);

    if (saveImage) {
      final ui.Picture picture = recorder.endRecording();
      saveCallback(picture);
    }
  }

  @override
  bool shouldRepaint(PainterCanvas oldDelegate) => false;
}

class PaintedPoints {
  Paint paint;
  Offset points;
  PaintedPoints({required this.points, required this.paint});
}

class PaintedCircles {
  Paint paint;
  Offset start;
  Offset end;
  PaintedCircles({required this.start, required this.end, required this.paint});
}

class PaintedArrow {
  Paint paint;
  Offset start;
  Offset end;
  PaintedArrow({required this.start, required this.end, required this.paint});
}

class PaintedSquires {
  Paint paint;
  Offset start;
  Offset end;
  PaintedSquires({required this.paint, required this.start, required this.end});
}