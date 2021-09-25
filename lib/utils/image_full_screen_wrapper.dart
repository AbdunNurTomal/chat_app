import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:chat_app/utils/painter.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uri_to_file/uri_to_file.dart';

class ImageDialogOld extends StatefulWidget {
  final String imageUri;
  final String imageName;
  final ui.Image myBackgroundImage;

  const ImageDialogOld({ Key? key, required this.myBackgroundImage, required this.imageUri, required this.imageName}) : super(key: key);

  @override
  State<ImageDialogOld> createState() => _ImageDialogOldState();
}

enum enumToolTypes { pencil, eraser, rectangle, circle, text, rotate, zoom, arrow }

class ToolIconsData {
  IconData icon;
  bool isSelected;
  enumToolTypes toolType;
  ToolIconsData(this.icon, this.toolType, {this.isSelected = false});
}
class RecordPaints{
  int? startIndex;
  int? endIndex;

  RecordPaints({this.startIndex, this.endIndex});
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

  List<PaintedArrow> arrowList = [];
  PaintedArrow unfinishedArrow = PaintedArrow(paint: Paint(),start: Offset(0.0,0.0),end: Offset(0.0,0.0));

  List<PaintedSquires> squaresList = [];
  PaintedSquires unfinishedSquare = PaintedSquires(paint: Paint(),start: Offset(0.0,0.0),end: Offset(0.0,0.0));

  List<PaintedCircles> circleList = [];
  PaintedCircles unfinishedCircle = PaintedCircles(paint: Paint(),start: Offset(0.0,0.0),end: Offset(0.0,0.0));

  StrokeCap strokeType = StrokeCap.square;
  double strokeWidth = 3.0;
  Color selectedColor = Colors.black;

  Paint getPoint() {
    if (selectedTool == enumToolTypes.eraser) {
      return Paint()
        ..strokeCap = strokeType
        ..isAntiAlias = true
        ..strokeWidth = 10.0
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
    pointsList.clear();
    paintListDeleted.clear();
    paintedPoints.clear();
    arrowList.clear();
    squaresList.clear();
    circleList.clear();
  }



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
      backgroundColor: Color(0xFFC0C0C0),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: (){
                  setState(() {
                    if (drawHistory.isNotEmpty) {
                      enumToolTypes lastAction = drawHistory
                          .last;
                      if (lastAction ==
                          enumToolTypes.eraser ||
                          lastAction ==
                              enumToolTypes.pencil) {
                        if (paintedPoints.isNotEmpty) {
                          RecordPaints lastPoint = paintedPoints
                              .last;
                          pointsList.removeRange(
                              lastPoint.startIndex!,
                              lastPoint.endIndex!);
                          paintedPoints.removeLast();
                        }
                      } else if (lastAction ==
                          enumToolTypes.rectangle) {
                        squaresList.removeLast();
                      } else {
                        circleList.removeLast();
                      }
                      drawHistory.removeLast();
                    }
                    //pointsListDeleted.;
                  });
              },
              icon: Icon(Icons.undo)
          ),
          IconButton(
            onPressed: (){
              setState(() {
                saveClicked = true;
              });
              Navigator.of(context).pop(context);
            },
            icon: Icon(Icons.save)
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            border: Border.symmetric(
                vertical: BorderSide(color: Colors.black54, width: 6)),
          ),
          padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  // color: Color(0xFFC0C0C0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: width * 1.0,
                          decoration: BoxDecoration(
                            // color: Colors.black,
                            //   borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                              boxShadow: [
                                BoxShadow(
                                  // color: Colors.black45.withOpacity(0.1),
                                  color: Colors.white.withOpacity(0.5),
                                  // blurRadius: 1.0,
                                  // spreadRadius: 0.1,
                                )]
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              width: constraints.widthConstraints().maxWidth,
                              height: constraints.heightConstraints().maxHeight,
                              color: Colors.black.withOpacity(0.7),
                              // height: height * 0.5,
                              // decoration: BoxDecoration(
                              //     // borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                              //     boxShadow: [
                              //       BoxShadow(
                              //         color: Colors.yellowAccent.withOpacity(0.3),
                              //         // blurRadius: 1.0,
                              //         // spreadRadius: 0.1,
                              //       )
                              //     ]),
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
                                    } else if (selectedTool == enumToolTypes.arrow) {
                                      unfinishedArrow.end = renderBox.globalToLocal(details.globalPosition);
                                    } else if (selectedTool == enumToolTypes.rectangle) {
                                      unfinishedSquare.end = renderBox.globalToLocal(details.globalPosition);
                                    } else if (selectedTool == enumToolTypes.circle) {
                                      unfinishedCircle.end = renderBox.globalToLocal(details.globalPosition);
                                    }
                                  });
                                },
                                onPanStart: (details) {
                                  if (isCanvasLocked) return;
                                  setState(() {
                                    final renderBox = context.findRenderObject() as RenderBox;
                                    if (selectedTool == enumToolTypes.pencil || selectedTool == enumToolTypes.eraser) {
                                      if (pointsList.isNotEmpty) {
                                        paintedPoints.add(RecordPaints(startIndex: pointsList.length, endIndex: null));
                                      } else {
                                        paintedPoints.add(RecordPaints(startIndex: null, endIndex: null));
                                      }
                                      pointsList.add(
                                        PaintedPoints(
                                          points: renderBox.globalToLocal(details.globalPosition),
                                          paint: getPoint(),
                                        ),
                                      );
                                    } else if (selectedTool == enumToolTypes.arrow) {
                                      unfinishedArrow = PaintedArrow(paint: Paint(),start: Offset(0.0,0.0),end: Offset(0.0,0.0));
                                      Offset os = renderBox.globalToLocal(details.globalPosition);
                                      unfinishedArrow.start = os;
                                      unfinishedArrow.end = os;
                                      unfinishedArrow.paint = getPoint();
                                    } else if (selectedTool == enumToolTypes.rectangle) {
                                      unfinishedSquare = PaintedSquires(paint: Paint(),start: Offset(0.0,0.0),end: Offset(0.0,0.0));
                                      Offset os = renderBox.globalToLocal(details.globalPosition);
                                      unfinishedSquare.start = os;
                                      unfinishedSquare.end = os;
                                      unfinishedSquare.paint = getPoint();
                                    } else if (selectedTool == enumToolTypes.circle) {
                                      unfinishedCircle = PaintedCircles(paint: Paint(),start: Offset(0.0,0.0),end: Offset(0.0,0.0));
                                      Offset os = renderBox.globalToLocal(details.globalPosition);
                                      //print("offset : $os");
                                      unfinishedCircle.start = os;
                                      unfinishedCircle.end = os;
                                      unfinishedCircle.paint = getPoint();
                                      //print("unfinishedCircle : ${unfinishedCircle.paint.color}");
                                    }
                                  });
                                },
                                onPanEnd: (details) {
                                  if (isCanvasLocked) return;
                                  setState(() {
                                    drawHistory.add(selectedTool);
                                    if (selectedTool == enumToolTypes.pencil || selectedTool == enumToolTypes.eraser) {
                                      paintedPoints.firstWhere((element) => element.endIndex == null).endIndex = pointsList.length;
                                      // pointsList.add(null);
                                    } else if (selectedTool == enumToolTypes.arrow) {
                                      setState(() {
                                        arrowList.add(unfinishedArrow);
                                        // unfinishedSquare = null;
                                        unfinishedArrow = PaintedArrow(paint: Paint(),start: Offset(0.0,0.0),end: Offset(0.0,0.0));
                                      });
                                    } else if (selectedTool == enumToolTypes.rectangle) {
                                      setState(() {
                                        squaresList.add(unfinishedSquare);
                                        // unfinishedSquare = null;
                                        unfinishedSquare = PaintedSquires(paint: Paint(),start: Offset(0.0,0.0),end: Offset(0.0,0.0));
                                      });
                                    } else if (selectedTool == enumToolTypes.circle) {
                                      setState(() {
                                        circleList.add(unfinishedCircle);
                                        // unfinishedCircle = null;
                                        unfinishedCircle = PaintedCircles(paint: Paint(),start: Offset(0.0,0.0),end: Offset(0.0,0.0));
                                      });
                                      print("circleList : ${circleList[0].paint},${circleList[0].start},${circleList[0].end}");
                                    }
                                  });
                                },
                                child: CustomPaint(
                                  size: Size(
                                      constraints.widthConstraints().maxWidth,
                                      constraints.heightConstraints().maxHeight),
                                  painter: PainterCanvas(
                                    image: widget.myBackgroundImage,
                                    pointsList: pointsList,
                                    arrowList: arrowList,
                                    squaresList: squaresList,
                                    circlesList: circleList,
                                    unfinishedArrow: unfinishedArrow,
                                    unfinishedSquare: unfinishedSquare,
                                    unfinishedCircle: unfinishedCircle,
                                    saveImage: saveClicked,
                                    saveCallback: (ui.Picture picture) async {
                                      Uri _uri = Uri.parse(widget.imageUri);
                                      File _file = await toFile(_uri);
                                      print("file name : $_file");

                                      final img = await picture.toImage(
                                          constraints.maxWidth.round(),
                                          constraints.maxHeight.round());
                                      ByteData? byteData = await img.toByteData(format: ui.ImageByteFormat.png);
                                      Uint8List jpgBytes = byteData!.buffer.asUint8List();

                                      var dir = await getExternalStorageDirectory();
                                      var testdir = await  Directory('${dir?.path}/images');

                                      File('${testdir.path}/${widget.imageName}').writeAsBytesSync(jpgBytes);

                                      showToastMessage("Image saved to gallery.");

                                      setState(() {
                                        saveClicked = false;
                                      });
                                    },
                                  ),
                                ),
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
                                color: Colors.white.withOpacity(0.5),
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
            ],
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
    ToolIconsData(FontAwesomeIcons.expandAlt, enumToolTypes.arrow),
    // ToolIconsData(FontAwesomeIcons.eraser, enumToolTypes.eraser),
    ToolIconsData(Icons.crop_square, enumToolTypes.rectangle),
    ToolIconsData(Icons.radio_button_unchecked, enumToolTypes.circle),
    ToolIconsData(Icons.text_fields, enumToolTypes.text), //TODO
    ToolIconsData(Icons.sync, enumToolTypes.rotate),
    ToolIconsData(FontAwesomeIcons.expand, enumToolTypes.zoom),
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
          width: 5,
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
      elevation: 0.1,
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
