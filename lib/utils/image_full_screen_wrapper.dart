import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/material.dart';
import 'package:uri_to_file/uri_to_file.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class ImageDialogOld extends StatefulWidget {
  final String imageUri;
  final String tag;
  final ui.Image myBackgroundImage;

  const ImageDialogOld({ Key? key, required this.myBackgroundImage, required this.imageUri, required this.tag}) : super(key: key);

  @override
  State<ImageDialogOld> createState() => _ImageDialogOldState();
}

class DrawingArea {
  Offset point;
  Paint areaPaint;
  DrawingArea({required this.point, required this.areaPaint});
}

class _ImageDialogOldState extends State<ImageDialogOld> {
  GlobalKey globalKey = GlobalKey();

  List<DrawingArea> points = [];
  double opacity = 1.0;
  StrokeCap strokeType = StrokeCap.round;
  double strokeWidth = 2.0;
  Color selectedColor = Colors.black;

  //var pictureRecorder = new ui.PictureRecorder();

  @override
  void initState() {
    super.initState();
    //selectedColor = Colors.red;
    //strokeWidth = 3.0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<File> _getLocalFile(String filename) async {
    Uri _uri = Uri.parse(filename);
    File _file = await toFile(_uri);
    //print("File - $_file");
    return _file;
  }
  Future<String> _getDirectoryPath() async{
    final directory = await getExternalStorageDirectory();
    final myImagePath = '${directory?.path}/MyImages';
    final myImgDir = await Directory(myImagePath).create();

    return myImagePath;
  }
  Future<void> _capturePng() async {
    RenderRepaintBoundary boundary = globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    //print(pngBytes);

/*
    String fileName = "FB_IMG_1627019045107.jpg";
    String dir = (await getApplicationDocumentsDirectory()).path;
    String savePath = '$dir/$fileName';

    if (await File(savePath).exists()) {
      print("File exists");
    } else {
      print("File don't exists $savePath");
    }

 */

    String fileName = "FB_IMG_1627019045107.jpg";
    final myImagePath = _getDirectoryPath();
    String savePath = '$myImagePath/$fileName';

    File imageFile = await _getLocalFile(savePath);
    print("Image file $imageFile");
    if( await File(savePath).exists()){
      imageFile.create(recursive: true);
    }else{
      print("Not Found");
    }
    imageFile.writeAsBytes(pngBytes);

    //if (!(await Permission.storage.status.isGranted))
    //  await Permission.storage.request();

    //final result = await ImageGallerySaver.saveImage(
    //    Uint8List.fromList(pngBytes),
    //    quality: 60,
    //    name: "canvas_image");
    //print(result);
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    void selectColor() {
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text('Color Chooser'),
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: selectedColor,
                onColorChanged: (color) {
                  this.setState(() {
                    selectedColor = color;
                  });
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Close"))
            ],
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
          children: <Widget>[
            /*
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(138, 35, 135, 1.0),
                      Color.fromRGBO(233, 64, 87, 1.0),
                      Color.fromRGBO(242, 113, 33, 1.0),
                    ])),
          ),

             */
          FloatingActionButton(
            heroTag: "paint_save",
            child: Icon(Icons.save),
            tooltip: 'Save',
            onPressed: () {
              //min: 0, max: 50
              setState(() {
                _capturePng();
              });
            },
          ),
          Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: width * 0.8,
                      height: height * 0.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 5.0,
                              spreadRadius: 1.0,
                            )
                          ]),
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            points.add(DrawingArea(
                                point: details.localPosition,
                                areaPaint: Paint()
                                  ..strokeCap = strokeType
                                  ..isAntiAlias = true
                                  ..color = selectedColor
                                  ..strokeWidth = strokeWidth));
                          });
                        },
                        onPanStart: (details) {
                          setState(() {
                            points.add(DrawingArea(
                                point: details.localPosition,
                                areaPaint: Paint()
                                  ..strokeCap = strokeType
                                  ..isAntiAlias = true
                                  ..color = selectedColor
                                  ..strokeWidth = strokeWidth));
                          });
                        },
                        onPanEnd: (details) {
                          setState(() {
                            //points = null;
                          });
                        },
                        child: SizedBox.expand(
                          child: RepaintBoundary(
                            key: globalKey,
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              //child: Hero(
                              //  tag: widget.tag,
                                child: Stack(
                                  children: [
                                    Center(
                                      child: FutureBuilder(
                                        future: _getLocalFile(widget.imageUri),
                                        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
                                          return snapshot.data != null ? Image.file(snapshot.data!) : Container();
                                        }
                                      ),
                                    ),
                                   CustomPaint(
                                     size: Size.infinite,
                                      painter: MyCustomPainter(
                                        points: points,
                                      ),
                                    ),
                                  ],
                                ),
                              //),
                            ),
                          ),
                        ),
                        //),
                        ///onTap: () {
                          //Navigator.pop(context);
                        //},
                      ),
                    ),
                  ),
                  Container(
                    width: width * 0.8,
                    decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                        icon: Icon(
                          Icons.color_lens,
                          color: selectedColor,
                        ),
                        onPressed: () {
                          selectColor();
                        }),

                        Expanded(
                          child: Slider(
                            min: 1.0,
                            max: 5.0,
                            label: "Stroke $strokeWidth",
                            activeColor: selectedColor,
                            value: strokeWidth,
                            onChanged: (double value) {
                              setState(() {
                                strokeWidth = value;
                              });
                            },
                          ),
                        ),

                        IconButton(
                            icon: Icon(
                              Icons.layers_clear,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState((){
                                points.clear();
                              });
                            }),
                      ],
                    ),
                  ),
                ]
              ),
          ),
        ],
      ),
    );
  }
}
class MyCustomPainter extends CustomPainter {
  final List<DrawingArea> points;
  List<Offset> offsetPoints = [];

  MyCustomPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.clipRect(rect);

    for (int x = 0; x < points.length - 1; x++) {
      if (points[x] != null && points[x + 1] != null) {
        canvas.drawLine(points[x].point, points[x + 1].point, points[x].areaPaint);
      } else if (points[x] != null && points[x + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(points[x].point);
        offsetPoints.add(Offset(points[x].point.dx + 0.1, points[x].point.dy + 0.1));

        canvas.drawPoints(ui.PointMode.points, offsetPoints, points[x].areaPaint);
      }
    }
  }

  @override
  bool shouldRepaint(MyCustomPainter oldDelegate) => true;
}
class SignaturePainter extends CustomPainter {
  final List<Offset> points;
  final int revision;

  SignaturePainter(this.points, [this.revision = 0]);

  void paint(canvas, Size size) {
    if (points.length < 2) return;

    Paint paint = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null)
        canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  // simplified this, but if you ever modify points instead of changing length you'll
  // have to revise.
  bool shouldRepaint(SignaturePainter other) => other.revision != revision;
}