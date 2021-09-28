import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfApiImageReport{
  // final pdf = Document();
  static List<Uint8List> imagesUint8list = [];

  static Future getImageBytes(String assetImage) async {
    final Uint8List byteList = File(assetImage).readAsBytesSync();
    imagesUint8list.add(byteList);
    print(imagesUint8list.length);
  }

  static Future createPdfFile() async {

  }
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

    for(var i=0;i<allImages.length;i++){
      assetImage.add(allImages[i].path);
    }
    //convert each image to Uint8List
    for (String image in assetImage) {
      await getImageBytes(image);
    }

    //create a list of images
    final List<pw.Widget> pdfImages = imagesUint8list.map((image) {
      // return pw.Column(
      //     crossAxisAlignment: pw.CrossAxisAlignment.center,
      //     mainAxisSize: pw.MainAxisSize.max,
      //     children: [
      //       // pw.Text(
      //       //     'Image'
      //       //         ' ' +
      //       //         (imagesUint8list
      //       //             .indexWhere((element) => element == image) +
      //       //             1)
      //       //             .toString(),
      //       //     style: pw.TextStyle(fontSize: 22)),
      //       // pw.SizedBox(height: 10),
      //       pw.Image(
      //           pw.MemoryImage(image,),
      //           // height: 400,
      //           fit: pw.BoxFit.cover)
      //     ]);
      return pw.FullPage(
        ignoreMargins: true,
        child: pw.Image(pw.MemoryImage(image), fit: pw.BoxFit.cover),
      );

    }).toList();

    //create PDF
    pdf.addPage(pw.MultiPage(
        // margin: pw.EdgeInsets.all(10),
        pageFormat: PdfPageFormat.legal,
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
            pw.Column(children: pdfImages),
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