import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:chat_app/models/defect.dart';
import 'package:chat_app/models/list_item.dart';
import 'package:chat_app/pages/report/add_list_item_dialog_widget.dart';
import 'package:chat_app/pages/report/list_item_widget.dart';
import 'package:chat_app/pages/report/pdf_api_image_report.dart';
import 'package:chat_app/pages/report/pdf_viewer_page.dart';
import 'package:chat_app/pages/report/video_viewer_page.dart';
import 'package:chat_app/provider/list_provider.dart';
import 'package:chat_app/provider/merge_provider.dart';
import 'package:chat_app/utils/circular_progress_dialog.dart';
import 'package:chat_app/utils/global_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as IMG;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:chat_app/pages/report/process_image_report.dart';
import 'package:uri_to_file/uri_to_file.dart';
import 'package:chat_app/utils/image_util.dart';

class TeameLeaderPage extends StatefulWidget {
  static const String routeName = "\team_leader";

  @override
  _TeameLeaderPageState createState() => _TeameLeaderPageState();
}

class PopUpMenuConstants{
  // static const String ProcessItem = 'Process';
  static const String SecondItem = 'Create Report';
  // static const String ThirdItem = 'Create Video Report';

  static const List<String> choices = <String>[
    // ProcessItem,
    SecondItem,
    // ThirdItem,
  ];

}
class _TeameLeaderPageState extends State<TeameLeaderPage> with SingleTickerProviderStateMixin {
  int counter = 0;

  late ListProvider allItem;
  late VideoProvider videoItem;
  var isBtnPDFPressed = false;
  var isBtnVideoPressed = false;

  late List<ListItem> taskItems;

  int progressIndicator=0;
  late var pdfImageFile;
  List<String> allImagePath = [];
  late var videoImageFile;

  bool videoLoading = false;

  @override
  void initState() {
    DefectData.callDefect();
    allItem = Provider.of<ListProvider>(context,listen: false);
    videoItem = Provider.of<VideoProvider>(context,listen: false);
    taskItems = allItem.allListItem;
    super.initState();
  }

  // Future<void> processChangeFileName() async{
  //   for(int i=0;i<allItem.allListItem.length;i++){
  //     int countImage=0;
  //     if(allItem.allListItem[i].images.isNotEmpty){
  //       String? itemSuffix = allItem.allListItem[i].itemValue;
  //       for(int j=0;j<allItem.allListItem[i].images.length;j++){
  //         countImage++;
  //         String? imageName = allItem.allListItem[i].images[j].name;
  //         String newImageName = '$itemSuffix\_$countImage.jpg';
  //         await ImageUtility.changeFileNameOnly(imageName!,newImageName,300);
  //       }
  //     }
  //   }
  // }
  Future<void> processChangeFileName() async{
    int countImg = 1;
    String imageDir = await ImageUtility.getImageDirPath();
    DefectImageData.allListImagesItem.sort((a,b) => a.newImgName!.compareTo(b.newImgName!));

    for (var element in DefectImageData.allListImagesItem) {
      if(await(File('$imageDir/${element.proImgName}').exists())){
        File('$imageDir/${element.proImgName}').renameSync('$imageDir/${element.newImgName}');
      }
      element.proImgName = element.newImgName;
      countImg++;
    }

    Directory imgDir = await ImageUtility.getImageDir();
    List<FileSystemEntity> fileList = await ImageUtility.dirContents(imgDir);
    fileList.sort((a,b) => a.path.compareTo(b.path));

    int countNewImage=1;
    int count =0;
    for (var f in fileList) {
      String proImgName = '$countNewImage.jpg';
      String proImgPath = '$imageDir/$proImgName';
      f.renameSync(proImgPath);
      DefectImageData.allListImagesItem[count].proImgName = proImgName;
      count++;

      Uint8List decodedBytes = await ImageUtility.compressFile(File(proImgPath),1024,768,0);
      decodedBytes[13] = 1;
      decodedBytes[14] = (300 >> 8);
      decodedBytes[15] = (300 & 0xff);
      decodedBytes[16] = (300 >> 8);
      decodedBytes[17] = (300 & 0xff);

      File(proImgPath).writeAsBytesSync(decodedBytes);
      allImagePath.add(proImgPath);
      countNewImage++;
    }
  }
  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
  );
  void openVideo(BuildContext context, File file) => Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => VideoViewerPage(file: file)),
  );
  // void _showProcessDialog(context) {
  //   // allItem.showCircularProgress(true);
  //   // DialogCircularBuilder(context).showLoadingIndicator(value: allItem.circularIndicator, text: '');
  //   // allItem = Provider.of<ListProvider>(context,listen: false);
  //   //print("Item <<>> ${allItem.allListItem[0].images[0].identifier}");
  //   // allItem.showBtnDownloadPDF(true);
  //   // allItem.showCircularProgress(false);
  //   // DialogCircularBuilder(context).hideOpenDialog();
  //
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         insetPadding: const EdgeInsets.all(8.0),
  //         title: const Center(child: Text('Precess Report File')),
  //         content: FutureBuilder(
  //           future: processChangeFileName(),
  //           builder: (context, snapshot) {
  //             if (snapshot.connectionState != ConnectionState.done) {
  //               return const SizedBox(
  //                 height: 50,
  //                 child: Center(child: CircularProgressIndicator.adaptive()),
  //               );
  //             }
  //             return SizedBox(
  //               width: MediaQuery
  //                   .of(context)
  //                   .size
  //                   .width * 0.8,
  //               height: 180,
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.stretch,
  //                 children: <Widget>[
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: <Widget>[
  //                       const Icon(Icons.picture_as_pdf_sharp),
  //                       const Padding(
  //                         padding: EdgeInsets.only(left: 8.0),
  //                         child: Text(' Create a Pdf report'),
  //                       ),
  //                       SizedBox(
  //                         child: AnimatedBuilder(
  //                           animation: _downloadControllers[0],
  //                           builder: (context, child) {
  //                             return DownloadButton(
  //                               status: _downloadControllers[0]
  //                                   .downloadStatus,
  //                               downloadProgress: _downloadControllers[0]
  //                                   .progress,
  //                               onDownload: _downloadControllers[0]
  //                                   .startDownload,
  //                               onCancel: _downloadControllers[0]
  //                                   .stopDownload,
  //                               onOpen: _downloadControllers[0].openDownload,
  //                             );
  //                           },
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 20.0),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: <Widget>[
  //                       const Icon(Icons.video_collection_sharp),
  //                       const Padding(
  //                         padding: EdgeInsets.only(left: 8.0),
  //                         child: Text(' Create a Video report'),
  //                       ),
  //                       SizedBox(
  //                         width: 96.0,
  //                         child: AnimatedBuilder(
  //                           animation: _downloadControllers[1],
  //                           builder: (context, child) {
  //                             return DownloadButton(
  //                               status: _downloadControllers[1]
  //                                   .downloadStatus,
  //                               downloadProgress: _downloadControllers[1]
  //                                   .progress,
  //                               onDownload: _downloadControllers[1]
  //                                   .startDownload,
  //                               onCancel: _downloadControllers[1]
  //                                   .stopDownload,
  //                               onOpen: _downloadControllers[1].openDownload,
  //                             );
  //                           },
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 40.0),
  //                   InkWell(
  //                     child: Container(
  //                       padding: const EdgeInsets.only(
  //                           top: 10.0, bottom: 10.0),
  //                       decoration: const BoxDecoration(
  //                         color: Colors.blue,
  //                         borderRadius: BorderRadius.all(Radius.circular(32)),
  //                         // borderRadius: BorderRadius.only(
  //                         //   bottomLeft: Radius.circular(32.0),
  //                         //   bottomRight: Radius.circular(32.0)
  //                         // ),
  //                       ),
  //                       child: const Text(
  //                         "Done",
  //                         style: TextStyle(color: Colors.white),
  //                         textAlign: TextAlign.center,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           }
  //         ),
  //       );
  //     },
  //   );
  // }
  void _showProcessDialog(context){
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(8.0),
          title: const Center(child: Text('Precess Report File')),
          content: FutureBuilder(
          future: processChangeFileName(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const SizedBox(
                height: 50,
                child: Center(child: CircularProgressIndicator.adaptive()),
              );
            }
            return SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.8,
              height: 180,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 20.0),
                  SizedBox(
                    child: TextButton.icon(
                      icon: const Icon(Icons.picture_as_pdf_sharp),
                      label: const Text('Open as PDF report'),
                      style: TextButton.styleFrom(backgroundColor: isBtnPDFPressed ? Colors.greenAccent : Colors.orangeAccent ),
                      onPressed: () async{
                        setState(() => isBtnPDFPressed = !isBtnPDFPressed);
                        String pdfReport = 'pdf_report.pdf';

                        var dir = await getExternalStorageDirectory();
                        String pdfPath = '${dir?.path}/$pdfReport';
                        if(await File(pdfPath).exists()){
                          await File(pdfPath).delete();
                        }

                        pdfImageFile = await PdfApiImageReport.generateImage(allImagePath, pdfReport);

                        if(pdfImageFile == null) return;
                        openPDF(context,pdfImageFile);
                      },
                    )
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    child: TextButton.icon(
                      icon: const Icon(Icons.picture_as_pdf_sharp),
                      label: const Text('Open as Video report'),
                      style: TextButton.styleFrom(backgroundColor: isBtnVideoPressed ? Colors.greenAccent : Colors.orangeAccent ),
                      onPressed: () async{
                        setState(() => isBtnVideoPressed = !isBtnVideoPressed);
                        String videoReport = 'video_report.mp4';
                        var dir = await getExternalStorageDirectory();
                        String videoPath = '${dir?.path}/$videoReport';
                        // if(await File(videoPath).exists()){
                        //   await File(videoPath).delete();
                        // }

                        // videoImageFile = await videoItem.videoMerger(videoPath);
                        String imagePath = await ImageUtility.getImageDirPath();

                        final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

                        setState(() => videoLoading = true);
                        allItem.showCircularProgress(true);
                        DialogCircularBuilder(context).showLoadingIndicator(value: allItem.circularIndicator, text: '');

                        String commandToExecute = '-f image2 -framerate 1 -i $imagePath/%d.jpg -y $videoPath';
                        await _flutterFFmpeg.execute(commandToExecute).then((rc) {
                          print('FFmpeg process exited with rc video report : $rc');
                          setState(() => videoLoading = false);
                        });

                        allItem.showCircularProgress(false);
                        DialogCircularBuilder(context).hideOpenDialog();

                        if(await File(videoPath).exists()){
                          openVideo(context,File(videoPath));
                        }else{
                          Fluttertoast.showToast(
                              msg: "Problem on create video",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 20.0
                          );
                        }
                      },
                    )
                  ),
                ]
              ),
            );
            }
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          title: Row(
            children: [
              SizedBox(
                  width:20,
                  child:Image.asset("images/pqc.png")
              ),
              const SizedBox(width:10),
              const Text('Pictures Report Form'),
            ],
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
              elevation: 20,
              enabled: true,
              onSelected: (value) async {
                if(allItem.allListItem.isNotEmpty){
                  switch(value){
                    case 'Process':
                      // _showProcessDialog(context);
                      break;
                    case 'Create Report':
                      _showProcessDialog(context);
                      break;
                  }
                }else{GlobalMethod.showAlertDialog(context,"Report Process Operation","No item found!!!");}
              },
              itemBuilder: (BuildContext context) {
                return PopUpMenuConstants.choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ],
        ),

        floatingActionButton: FloatingActionButton(
          child: const Text(
            '+',
            style: TextStyle(fontSize: 20.0),
          ),
          shape: RoundedRectangleBorder(
              side: const BorderSide(
                  color: Colors.black26, width: 1.0, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(10.0)),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AddListItemDialogWidget(),
              barrierDismissible: false,
            ),
        ),
        body:  Container(
            //margin: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
                //border: Border.all(
                //  color: Colors.black12,
                //  width: 3,
                //),
                //borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),

            // showAlertDialog(context),
            child: ListItemWidget()
        ),
    );
  }
}