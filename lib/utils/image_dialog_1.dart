import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';


class ImageDialog extends StatefulWidget {
  final File? imageUri;
  final String tag;
  final ui.Image myBackgroundImage;

  const ImageDialog({ Key? key, required this.myBackgroundImage, required this.imageUri, required this.tag}) : super(key: key);

  @override
  State<ImageDialog> createState() => _ImageDialogState();
}

class DrawingArea {
  Offset point;
  Paint areaPaint;
  DrawingArea({required this.point, required this.areaPaint});
}

class _ImageDialogState extends State<ImageDialog> {
  List<DrawingArea> points = [];
  late Color selectedColor;
  late double strokeWidth;

  @override
  void initState() {
    super.initState();
    selectedColor = Colors.black;
    strokeWidth = 2.0;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //myBackgroundImage.dispose();
  }
  @override
  Widget build(BuildContext context) {
    print("Image dialog 1 >> ${widget.myBackgroundImage}");

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
      backgroundColor: Colors.black87,
      body:Stack(
        children: <Widget>[
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
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 5.0,
                            spreadRadius: 1.0,
                          )
                        ]),
                    child: GestureDetector(
                      onPanDown: (details) {
                        this.setState(() {
                          points.add(DrawingArea(
                              point: details.localPosition,
                              areaPaint: Paint()
                                ..strokeCap = StrokeCap.round
                                ..isAntiAlias = true
                                ..color = selectedColor
                                ..strokeWidth = strokeWidth));
                        });
                      },
                      onPanUpdate: (details) {
                        this.setState(() {
                          points.add(DrawingArea(
                              point: details.localPosition,
                              areaPaint: Paint()
                                ..strokeCap = StrokeCap.round
                                ..isAntiAlias = true
                                ..color = selectedColor
                                ..strokeWidth = strokeWidth));
                        });
                      },
                      onPanEnd: (details) {
                        this.setState(() {
                          points.add(DrawingArea(
                              point: Offset(0.0,0.0),
                              areaPaint: Paint()));
                        });
                      },
                      child: SizedBox.expand(
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          child: CustomPaint(
                            painter: MyCustomPainter(
                                points: points,
                                //myImage: myImage,
                                myBackgroundImage: widget.myBackgroundImage,
                            ),
                          ),
                        ),
                      ),
                    ),

                  ),
                ),
                Container(
                  width: width * 0.95,
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
                            this.setState(() {
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
                            this.setState((){
                              points.clear();
                            });
                          }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
    /*
    GestureDetector(
        child: Center(
          child: Hero(
            tag: widget.tag,
            child: FutureBuilder(
                future: _getLocalFile(widget.imageUri),
                builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
                  //print("Sanpshot - $snapshot");
                  return snapshot.data != null ? Image.file(snapshot.data!) : Container();
                }),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
    */

  }
}
class MyCustomPainter extends CustomPainter {
  final List<DrawingArea> points;
  final ui.Image myBackgroundImage;

  MyCustomPainter({required this.points, required this.myBackgroundImage});

  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = Colors.white;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);
    canvas.clipRect(rect);

    print("myBackgroundImage $myBackgroundImage");
    canvas.drawImage(myBackgroundImage, Offset.zero, Paint());

    for (int x = 0; x < points.length - 1; x++) {
      if (points[x] != null && points[x + 1] != null) {
        canvas.drawLine(points[x].point, points[x + 1].point, points[x].areaPaint);
      } else if (points[x] != null && points[x + 1] == null) {
        canvas.drawPoints(ui.PointMode.points, [points[x].point], points[x].areaPaint);
      }
    }
  }

  @override
  bool shouldRepaint(MyCustomPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
