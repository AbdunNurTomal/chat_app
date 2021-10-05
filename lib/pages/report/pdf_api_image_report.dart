import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:chat_app/utils/image_util.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfApiImageReport{
  // final pdf = Document();
  // static List<Uint8List> imagesUint8list = [];
  // static int counter =0;
  //
  // static Future getImageBytes(String assetImage) async {
  //   final Uint8List byteList = File(assetImage).readAsBytesSync();
  //   if(counter ==0) {
  //     ui.Image _myBackgroundImage = await ImageUtility.loadImage(byteList);
  //   }
  //   imagesUint8list.add(byteList);
  //   // print(imagesUint8list.length);
  // }

  // static Future savePdfFile() async {
  //   Directory documentDirectory = await getApplicationDocumentsDirectory();
  //
  //   String documentPath = documentDirectory.path;
  //
  //   String id = DateTime.now().toString();
  //
  //   File file = File("$documentPath/$id.pdf");
  //
  //   file.writeAsBytesSync(await pdf.save());
  //   setState(() {
  //     pdfFile = file.path;
  //     pdf = pw.Document();
  //   });
  // }

  static Future<File> generateImage(List<FileSystemEntity> allImages) async {
    final pdf = pw.Document();
    List<String> assetImage = [];
    List<Uint8List> imagesUint8list = [];
    int counter =0;

    // print("PDF >> ${allImages.length}");

    for(var i=0;i<allImages.length;i++){
      print(">>> ${allImages[i].path}");
      assetImage.add(allImages[i].path);
    }

    //convert each image to Uint8List
    for (String image in assetImage) {
      // await getImageBytes(image);

      final Uint8List byteList = File(image).readAsBytesSync();
      if(counter ==0) {
        ui.Image _myBackgroundImage = await ImageUtility.loadImage(byteList);
      }
      imagesUint8list.add(byteList);
      // print(imagesUint8list.length);
    }

    //create a list of images
    final List<pw.Widget> pdfImages = imagesUint8list.map((image) {
      // return pw.Column(
      //     crossAxisAlignment: pw.CrossAxisAlignment.center,
      //     mainAxisSize: pw.MainAxisSize.max,
      //     children: [
      //       pw.Image(
      //           pw.MemoryImage(image),
      //           fit: pw.BoxFit.contain)
      //     ]);
      return pw.Wrap(
          children: [
            // pw.Text(
            //     'Image'
            //         ' ' +
            //         (imagesUint8list
            //             .indexWhere((element) => element == image) +
            //             1)
            //             .toString(),
            //     style: pw.TextStyle(fontSize: 22)),
            // pw.SizedBox(height: 10),
            pw.Image(
                pw.MemoryImage(image),
                // height: 400,
                fit: pw.BoxFit.contain),
            // pw.SizedBox(height: 5),
          ]);
      // return pw.FullPage(
      //   ignoreMargins: true,
      //   child: pw.Image(pw.MemoryImage(image), fit: pw.BoxFit.cover),
      // );

    }).toList();

    //create PDF
    pdf.addPage(pw.MultiPage(
        margin: pw.EdgeInsets.all(0),
        // pageFormat: PdfPageFormat(15*PdfPageFormat.inch,11.27*PdfPageFormat.inch).landscape,
        // pageFormat: const PdfPageFormat(14.25*PdfPageFormat.inch,10.67*PdfPageFormat.inch).landscape,
        pageFormat: const PdfPageFormat(14.23*PdfPageFormat.inch,10.67*PdfPageFormat.inch).landscape,
        build: (pw.Context context) {
          return <pw.Widget>[
            // pw.Column(
            //     crossAxisAlignment: pw.CrossAxisAlignment.center,
            //     mainAxisSize: pw.MainAxisSize.min,
            //     children: [
            //       pw.Text('Pacific Quality Control Center Ltd.-PQC',
            //           textAlign: pw.TextAlign.center,
            //           style: pw.TextStyle(fontSize: 26)),
            //       pw.Divider(),
            //     ]),
            // pw.Column(children: pdfImages),
            pw.Wrap(children: pdfImages),
          ];
        }));
    // await savePdfFile();


    //
    // String imagePath = allImages[0].path;
    // Uint8List decodedBytes = await ImageUtility.compressImageList(File(imagePath).readAsBytesSync(),1200,1200,270);
    //
    // final pageTheme = PageTheme(
    //   pageFormat: PdfPageFormat.,
    //   buildBackground: (context) {
    //     if (context.pageNumber == 1) {
    //       return FullPage(
    //         ignoreMargins: true,
    //         child: Image(MemoryImage(decodedBytes), fit: BoxFit.cover),
    //       );
    //     } else {
    //       return Container();
    //     }
    //   },
    // );
    //
    // pdf.addPage(
    //   MultiPage(
    //     pageTheme: pageTheme,
    //     build: (context) => [
    //       Container(),
    //       // Image(MemoryImage(_imageBytes)),
    //     ],
    //   ),
    // );

    return saveDocument(name: 'my_example.pdf', pdf: pdf);
  }
  static Future<File> saveDocument({
    required String name,
    required pw.Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getExternalStorageDirectory();
    final file = File('${dir?.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }
}