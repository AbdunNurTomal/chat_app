import 'dart:io';
import 'dart:ui' as ui;
import 'package:chat_app/utils/painter.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uri_to_file/uri_to_file.dart';

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
enum enumToolTypes { pencil, eraser, rectangle, circle, text }

class ToolIconsData {
  IconData icon;
  bool isSelected;
  enumToolTypes toolType;
  ToolIconsData(this.icon, this.toolType, {this.isSelected = false});
}
class RecordPaints{
  int? startIndex;
  int? endIndex;

  RecordPaints(this.startIndex, this.endIndex);
}

class _ImageDialogOldState extends State<ImageDialogOld> {
  GlobalKey globalKey = GlobalKey();

  List<PaintedPoints> pointsList = [];
  List<PaintedPoints> paintListDeleted = [];
  List<RecordPaints> paintedPoints = [];
  // late RecordPaints? recordPaints;
  //List<DrawingArea> points = [];

  enumToolTypes selectedTool = enumToolTypes.pencil;
  List<enumToolTypes> drawHistory = [];

  bool isCanvasLocked = false;
  bool saveClicked = false;

  List<PaintedSquires> squaresList = [];
  late PaintedSquires? unfinishedSquare;

  List<PaintedCircles> circleList = [];
  late PaintedCircles? unfinishedCircle;

  StrokeCap strokeType = StrokeCap.square;
  double strokeWidth = 3.0;
  Color selectedColor = Colors.black;

  Paint getPoint() {
    if (selectedTool == enumToolTypes.eraser) {
      return Paint()
        ..strokeCap = strokeType
        ..isAntiAlias = true
        ..strokeWidth = strokeWidth
        ..color = Colors.white;
    } else {
      return Paint()
        ..strokeCap = strokeType
        ..isAntiAlias = true
        ..strokeWidth = strokeWidth
        ..color = selectedColor;
    }
  }

  void showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  double opacity = 1.0;


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
/*
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
*/
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;

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
                  setState(() {
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
                  child: const Text("Close"))
            ],
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          // decoration: const BoxDecoration(
          //   border: Border.symmetric(
          //       vertical: BorderSide(color: Colors.black54, width: 6)),
          // ),
          padding: const EdgeInsets.all(1.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Container(
                //   width: width * 0.9,
                //   height: height * 0.1,
                //   decoration: BoxDecoration(
                //       borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.blue.withOpacity(0.3),
                //           blurRadius: 1.0,
                //           // spreadRadius: 0.1,
                //         )
                //       ]),
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: <Widget>[
                //       GestureDetector(
                //         onTap: () {
                //           setState(() {
                //             saveClicked = true;
                //           });
                //         },
                //         child: MenuItem("Save"),
                //       ),
                //       GestureDetector(
                //         onTap: () {
                //           setState(() {
                //             if (drawHistory.isNotEmpty) {
                //               enumToolTypes lastAction = drawHistory.last;
                //               if (lastAction == enumToolTypes.eraser || lastAction == enumToolTypes.pencil) {
                //                 if (paintedPoints.isNotEmpty) {
                //                   RecordPaints lastPoint = paintedPoints.last;
                //                   pointsList!.removeRange(lastPoint.startIndex!, lastPoint.endIndex!);
                //                   paintedPoints.removeLast();
                //                 }
                //               } else if (lastAction == enumToolTypes.rectangle) {
                //                 squaresList.removeLast();
                //               } else {
                //                 circleList.removeLast();
                //               }
                //               drawHistory.removeLast();
                //             }
                //             //pointsListDeleted.;
                //           });
                //         },
                //         child: MenuItem("Undo"),
                //       ),
                //       GestureDetector(
                //         onTap: () {
                //           setState(() {
                //             pointsList!.clear();
                //             paintedPoints.clear();
                //             squaresList.clear();
                //             circleList.clear();
                //           });
                //         },
                //         child: MenuItem("Clear"),
                //       ),
                //     ],
                //   ),
                // ),
                Container(
                  width: width * 1.0,
                  decoration: BoxDecoration(
                    // color: Colors.black,
                      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45.withOpacity(0.1),
                          // blurRadius: 1.0,
                          // spreadRadius: 0.1,
                        )]
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(children: getToolBoxIcons()),
                      // const SizedBox(height: 20),
                      // Container(
                      //   width: 80,
                      //   height: 90,
                      //   decoration: BoxDecoration(
                      //     border: Border.all(color: Colors.grey, width: 2),
                      //   ),
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: <Widget>[
                      //       strokeWidthWidget(3),
                      //       strokeWidthWidget(5),
                      //       strokeWidthWidget(7),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Container(
                      width: width * 0.9,
                      // height: height * 0.7,
                      decoration: BoxDecoration(
                          // borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.yellowAccent.withOpacity(0.3),
                              // blurRadius: 1.0,
                              // spreadRadius: 0.1,
                            )
                          ]),
                      child: GestureDetector(
                        key: globalKey,
                        onPanUpdate: (details) {
                          if (isCanvasLocked) return;
                          setState(() {
                            final renderBox = context.findRenderObject() as RenderBox;
                            if (selectedTool == enumToolTypes.pencil || selectedTool == enumToolTypes.eraser) {
                              pointsList.add(
                                PaintedPoints(
                                  points: renderBox.globalToLocal(details.globalPosition),
                                  paint: getPoint(),
                                ),
                              );
                            } else if (selectedTool == enumToolTypes.rectangle) {
                              unfinishedSquare!.end = renderBox.globalToLocal(details.globalPosition);
                            } else if (selectedTool == enumToolTypes.circle) {
                              unfinishedCircle!.end = renderBox.globalToLocal(details.globalPosition);
                            }
                          });
                        },
                        onPanStart: (details) {
                          if (isCanvasLocked) return;
                          setState(() {
                            final renderBox = context.findRenderObject() as RenderBox;
                            if (selectedTool == enumToolTypes.pencil || selectedTool == enumToolTypes.eraser) {
                              if (pointsList.isNotEmpty) {
                                paintedPoints.add(RecordPaints(pointsList.length, null));
                              } else {
                                paintedPoints.add(RecordPaints(0, null));
                              }
                              pointsList.add(
                                PaintedPoints(
                                  points: renderBox.globalToLocal(details.globalPosition),
                                  paint: getPoint(),
                                ),
                              );
                            } else if (selectedTool == enumToolTypes.rectangle) {
                              unfinishedSquare = PaintedSquires(null,null,null);
                              Offset os = renderBox.globalToLocal(details.globalPosition);
                              unfinishedSquare!.start = os;
                              unfinishedSquare!.end = os;
                              unfinishedSquare!.paint = getPoint();
                            } else if (selectedTool == enumToolTypes.circle) {
                              unfinishedCircle = PaintedCircles(null,null,null);
                              Offset os = renderBox.globalToLocal(details.globalPosition);
                              unfinishedCircle!.start = os;
                              unfinishedCircle!.end = os;
                              unfinishedCircle!.paint = getPoint();
                            }
                          });
                        },
                        onPanEnd: (details) {
                          if (isCanvasLocked) return;
                          setState(() {
                            drawHistory.add(selectedTool);
                            if (selectedTool == enumToolTypes.pencil || selectedTool == enumToolTypes.eraser) {
                              paintedPoints.firstWhere((element) => element.endIndex == null).endIndex = pointsList.length;
                              // pointsList.add();
                            } else if (selectedTool == enumToolTypes.rectangle) {
                              setState(() {
                                squaresList.add(unfinishedSquare!);
                                unfinishedSquare = null;
                              });
                            } else if (selectedTool == enumToolTypes.circle) {
                              setState(() {
                                circleList.add(unfinishedCircle!);
                                unfinishedCircle = null;
                              });
                            }
                          });
                        },
                        // child: SizedBox.expand(
                        //   child: RepaintBoundary(
                        //     key: globalKey,
                        //     child: ClipRRect(
                        //       // borderRadius: const BorderRadius.all(
                        //       //     Radius.circular(10.0)),
                        //       //child: Hero(
                        //       //  tag: widget.tag,
                        //       child: Stack(
                        //         children: [
                        //           ClipRect(
                        //             child: Container(
                        //               //Canvas
                        //               color: Colors.white,
                        //               //margin: EdgeInsets.only(bottom: 50, right: 80),
                        //               child: CustomPaint(
                        //                 size: Size(
                        //                     constraints.widthConstraints().maxWidth,
                        //                     constraints
                        //                         .heightConstraints()
                        //                         .maxHeight),
                        //                 // painter: PainterCanvas(
                        //                 //   pointsList: paintList,
                        //                 //   squaresList: squaresList,
                        //                 //   circlesList: circleList,
                        //                 //   unfinishedSquare: unfinishedSquare,
                        //                 //   unfinishedCircle: unfinishedCircle,
                        //                 //   saveImage: saveClicked,
                        //                 //   // saveCallback: (Picture picture) async {
                        //                 //   //   var status =
                        //                 //   //   await Permission.storage.status;
                        //                 //   //   if (!status.isGranted) {
                        //                 //   //     await Permission.storage.request();
                        //                 //   //   }
                        //                 //   //   if (status.isGranted) {
                        //                 //   //     final img = await picture.toImage(
                        //                 //   //         constraints.maxWidth.round(),
                        //                 //   //         constraints.maxHeight.round());
                        //                 //   //     final bytes = await img.toByteData(
                        //                 //   //         format: ImageByteFormat.png);
                        //                 //   //     await ImageGallerySaver.saveImage(
                        //                 //   //       Uint8List.fromList(
                        //                 //   //           bytes.buffer.asUint8List()),
                        //                 //   //       quality: 100,
                        //                 //   //       name:
                        //                 //   //       DateTime.now().toIso8601String(),
                        //                 //   //     );
                        //                 //   //     showToastMessage(
                        //                 //   //         "Image saved to gallery.");
                        //                 //   //   }
                        //                 //   //   setState(() {
                        //                 //   //     saveClicked = false;
                        //                 //   //   });
                        //                 //   // },
                        //                 // ),
                        //               ),
                        //             ),
                        //           ),
                        //           Center(
                        //             child: FutureBuilder(
                        //                 future: _getLocalFile(widget.imageUri),
                        //                 builder: (BuildContext context,
                        //                     AsyncSnapshot<File> snapshot) {
                        //                   return snapshot.data != null
                        //                       ? Image.file(snapshot.data!)
                        //                       : Container();
                        //                 }
                        //             ),
                        //           ),
                        //           // CustomPaint(
                        //           //   size: Size.infinite,
                        //           //   painter: MyCustomPainter(
                        //           //     //points: points,
                        //           //   ),
                        //           // ),
                        //         ],
                        //       ),
                        //       //),
                        //     ),
                        //   ),
                        // ),
                      ),
                    );
                  }),
                ),
                Container(
                  width: width * 1.0,
                  decoration: BoxDecoration(
                      // color: Colors.black,
                      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [
                          BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          // blurRadius: 1.0,
                          // spreadRadius: 0.1,
                        )]
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          icon: const Icon(
                            Icons.layers_clear,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState((){
                              // points.clear();
                              pointsList.clear();
                              paintedPoints.clear();
                              squaresList.clear();
                              circleList.clear();
                            });
                          }),
                      IconButton(
                          tooltip: isCanvasLocked
                              ? "Click to unlock drawing"
                              : "Click to lock drawing",
                          icon: Icon(
                            isCanvasLocked ? Icons.lock_outline : Icons.lock_open,
                          ),
                          onPressed: () {
                            setState(() {
                              isCanvasLocked = !isCanvasLocked;
                            });
                          })
                    ],
                  ),
                ),
              ]
            ),
        ),
      ),
    );
  }
  Widget strokeWidthWidget(double width) {
    bool isSelected = strokeWidth == width ? true : false;
    return Container(
      padding: EdgeInsets.symmetric(vertical: (10 - width), horizontal: 2),
      decoration: BoxDecoration(
        border: Border.all(
            width: 1, color: isSelected ? Colors.black : Colors.grey),
      ),
      child: Material(
        elevation: isSelected ? 1 : 0,
        child: InkWell(
          onTap: () {
            setState(() {
              strokeWidth = width;
            });
          },
          child: Container(
            width: 50,
            height: width,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
  List<ToolIconsData> lstToolIcons = [
    ToolIconsData(Icons.create, enumToolTypes.pencil, isSelected: true),
    ToolIconsData(FontAwesomeIcons.eraser, enumToolTypes.eraser),
    ToolIconsData(Icons.crop_square, enumToolTypes.rectangle),
    ToolIconsData(Icons.radio_button_unchecked, enumToolTypes.circle),

    // ToolIconsData(Icons.text_fields, enumToolTypes.text), //TODO
  ];
  List<Widget> getToolBoxIcons() {
    List<Widget> lstWidgets = [];
    for (ToolIconsData item in lstToolIcons) {
      lstWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedTool = item.toolType;
              lstToolIcons
                  .firstWhere((element) => element.isSelected == true)
                  .isSelected = false;
              lstToolIcons
                  .firstWhere((element) => element.icon == item.icon)
                  .isSelected = true;
            });
          },
          child: ToolIcon(
            item.icon,
            isActive: item.isSelected,
          ),
        ),
      );
    }
    return lstWidgets;
  }
}
class MenuItem extends StatelessWidget {
  final String itemName;
  MenuItem(this.itemName);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InkWell(
          child: Text(itemName),
        ),
        const SizedBox(
          width: 10,
        )
      ],
    );
  }
}
class ToolIcon extends StatelessWidget {
  final IconData iconData;
  final bool isActive;
  ToolIcon(this.iconData, {this.isActive = false});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      elevation: 0.5,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      color: isActive ? Colors.white24 : Colors.white,
      child: Container(
        child: IconButton(icon: Icon(iconData), onPressed: null),
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