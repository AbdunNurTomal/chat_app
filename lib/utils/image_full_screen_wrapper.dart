import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:chat_app/models/defect.dart';
import 'package:chat_app/models/list_image_item.dart';
import 'package:chat_app/utils/painter.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_painter/flutter_painter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'image_util.dart';

class ImageDialogOld extends StatefulWidget {
  final String itemName;
  final ui.Image backgroundImage;
  final int imageIndex;
  final String editedName;

  const ImageDialogOld({ Key? key, required this.backgroundImage, required this.imageIndex, required this.itemName, required this.editedName}) : super(key: key);

  @override
  State<ImageDialogOld> createState() => _ImageDialogOldState();
}

enum enumToolTypes { pencil, eraser, rectangle, circle, text, arrow }

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

  bool isCanvasLocked = false;
  bool saveClicked = false;
  StrokeCap strokeType = StrokeCap.square;
  // late double strokeWidth;
  // late Color selectedColor;

  enumToolTypes selectedTool = enumToolTypes.pencil;

  static const Color selectedColor = Color(0xFFFF0000);
  FocusNode textFocusNode = FocusNode();
  late PainterController controller;
  ui.Image? backgroundImage;

  @override
  void initState() {
    super.initState();
    controller = PainterController(
      settings: PainterSettings(
        text: TextSettings(
          focusNode: textFocusNode,
          textStyle: TextStyle(
            fontWeight: FontWeight.bold, color: selectedColor, fontSize: 18),
        ),
        freeStyle: FreeStyleSettings(
          enabled: false,
          color: selectedColor,
          strokeWidth: 5,
        )));
    textFocusNode.addListener(onFocus);
    initBackground();
  }

  void initBackground() async {
    setState(() {
      backgroundImage = widget.backgroundImage;
      controller.background = widget.backgroundImage.backgroundDrawable;
    });
  }

  void onFocus() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFC0C0C0),
      appBar: AppBar(
        // title: Text("Flutter Painter Example"),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.undo,
            ),
            onPressed: removeLastDrawable,
          ),
          IconButton(
            onPressed: () {
              renderAndDisplayImage();
              Navigator.of(context).pop(widget.imageIndex);
            },
            icon: const Icon(Icons.save)
          )
        ],
      ),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            border: Border.symmetric(
                vertical: BorderSide(color: Colors.black54, width: 4)),
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(4.0),
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(
            children: [
              Container(
                height: constraints.maxHeight * 0.1,
                width: constraints.maxWidth * 1.0,
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
                  ],
                ),
              ),
              if (backgroundImage != null)
              // Enforces constraints
              if (controller.freeStyleSettings.enabled) ...[
                // Control free style stroke width
                Slider.adaptive(
                    min: 3,
                    max: 15,
                    value: controller.freeStyleSettings.strokeWidth,
                    onChanged: setFreeStyleStrokeWidth),

                // Control free style color hue
                Slider.adaptive(
                    min: 0,
                    max: 359.99,
                    value:
                    HSVColor.fromColor(controller.freeStyleSettings.color).hue,
                    activeColor: controller.freeStyleSettings.color,
                    onChanged: setFreeStyleColor),
              ],
              if (textFocusNode.hasFocus) ...[
                // Control text font size
                Slider.adaptive(
                    min: 12,
                    max: 48,
                    value: controller.textSettings.textStyle.fontSize ?? 14,
                    onChanged: setTextFontSize),

                // Control text color hue
                Slider.adaptive(
                    min: 0,
                    max: 359.99,
                    value: HSVColor.fromColor(
                        controller.textSettings.textStyle.color ?? selectedColor)
                        .hue,
                    activeColor: controller.textSettings.textStyle.color,
                    onChanged: setTextColor),
              ],
              AspectRatio(
                aspectRatio: backgroundImage!.width / backgroundImage!.height,
                child: FlutterPainter(
                  controller: controller,
                ),
              ),
            ],
          );
          }),
        ),
      ),
    );
  }
  void setFreeStyleColor(double hue) {
    setState(() {
      controller.freeStyleSettings = controller.freeStyleSettings.copyWith(
        color: HSVColor.fromAHSV(1, hue, 1, 1).toColor(),
      );
    });
  }
  // void selectColor() {
  //   showDialog(
  //     context: context,
  //     builder: (context){
  //       return AlertDialog(
  //         title: const Text('Color Chooser'),
  //         content: SingleChildScrollView(
  //           child: BlockPicker(
  //             pickerColor: selectedColor,
  //             onColorChanged: (color) {
  //               setState(() {
  //                 selectedColor = color;
  //                 controller.freeStyleSettings = controller.freeStyleSettings.copyWith(
  //                   color: Colors.red,
  //                 );
  //               });
  //             },
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: const Text("Close"))
  //         ],
  //       );
  //     },
  //   );
  // }
  void removeLastDrawable() {
    controller.removeLastDrawable();
  }

  void toggleFreeStyle() {
    setState(() {
      controller.freeStyleSettings = controller.freeStyleSettings
          .copyWith(enabled: !controller.freeStyleSettings.enabled);
    });
  }
  void addText() {
    if (controller.freeStyleSettings.enabled) toggleFreeStyle();
    controller.addText();
  }
  void setFreeStyleStrokeWidth(double value) {
    setState(() {
      controller.freeStyleSettings =
          controller.freeStyleSettings.copyWith(strokeWidth: value);
    });
  }

  void setTextFontSize(double size) {
    // Set state is just to update the current UI, the [FlutterPainter] UI updates without it
    setState(() {
      controller.textSettings = controller.textSettings.copyWith(
          textStyle:
          controller.textSettings.textStyle.copyWith(fontSize: size));
    });
  }
  void setTextColor(double hue) {
    // Set state is just to update the current UI, the [FlutterPainter] UI updates without it
    setState(() {
      controller.textSettings = controller.textSettings.copyWith(
          textStyle: controller.textSettings.textStyle.copyWith(
            color: HSVColor.fromAHSV(1, hue, 1, 1).toColor(),
          ));
    });
  }

  Future<void> renderAndDisplayImage() async{
    // String imageDir = await ImageUtility.getImageDirPath();
    if (backgroundImage == null) return;

    final backgroundImageSize = Size(
        backgroundImage!.width.toDouble(), backgroundImage!.height.toDouble());

    final imageFuture = controller
        .renderImage(backgroundImageSize)
        .then<Uint8List?>((ui.Image image) async{
          ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
          Uint8List newJpgBytes = await ImageUtility.compressImageList(byteData!.buffer.asUint8List(),1600,1200,270);
          File(widget.editedName).writeAsBytesSync(newJpgBytes);
        });

    showDialog(
        context: context,
        builder: (context) {
          return RenderedImageDialog(imageFuture: imageFuture);
        });

    // print("widget.editedName ${DefectImageData.allListImagesItem[0].newImgName}");
    String editedImgName = widget.editedName.split(' / ').last;
    // final foundImg = DefectImageData.allListImagesItem.where((element) => ((element.oldImgName == editedImgName)||(element.newImgName == editedImgName)||(element.proImgName == editedImgName)));
    // if(foundImg.isNotEmpty){
      DefectImageData.updateImageItem(editedImgName);
    // }

    Navigator.pop(context);
  }

  List<ToolIconsData> lstToolIcons = [
    ToolIconsData(Icons.create, enumToolTypes.pencil, isSelected: true),
    ToolIconsData(FontAwesomeIcons.expandAlt, enumToolTypes.arrow),
    // ToolIconsData(FontAwesomeIcons.eraser, enumToolTypes.eraser),
    ToolIconsData(Icons.crop_square, enumToolTypes.rectangle),
    ToolIconsData(Icons.radio_button_unchecked, enumToolTypes.circle),
    ToolIconsData(Icons.text_fields, enumToolTypes.text), //TODO
    // ToolIconsData(Icons.sync, enumToolTypes.rotate),
    // ToolIconsData(FontAwesomeIcons.expand, enumToolTypes.zoom),
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

              if(selectedTool == enumToolTypes.pencil){
                toggleFreeStyle();
              }else{
                controller.freeStyleSettings = controller.freeStyleSettings
                    .copyWith(enabled: false);
              }
              if(selectedTool == enumToolTypes.text){
                addText();
              }
            });
          },
          child: ToolIcon(
            item.icon,
            controller,
            isActive: item.isSelected,
          ),
        ),
      );
    }
    return lstWidgets;
  }

}
class ToolIcon extends StatelessWidget {
  final IconData iconData;
  final bool isActive;
  final PainterController controller;
  ToolIcon(this.iconData, this.controller, {this.isActive = false});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      elevation: 0.1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      color: isActive ? Colors.white24 : Colors.white,
      child: Container(
        child: IconButton(
            icon: Icon(iconData),
            onPressed: null),
      ),
    );
  }
}
class RenderedImageDialog extends StatelessWidget {
  final Future<Uint8List?> imageFuture;

  const RenderedImageDialog({Key? key, required this.imageFuture})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Rendered Image"),
      content: FutureBuilder<Uint8List?>(
        future: imageFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox(
              height: 50,
              child: Center(child: CircularProgressIndicator.adaptive()),
            );
          }
          // if (!snapshot.hasData || snapshot.data == null)
            return const SizedBox();
          // return InteractiveViewer(
          //     maxScale: 10, child: Image.memory(snapshot.data!));
        },
      ),
    );
  }
}
