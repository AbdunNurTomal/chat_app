import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';

class PDFViewerPage extends StatefulWidget {
  final File file;

  const PDFViewerPage({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  late PDFViewController controller;
  int pages = 0;
  int indexPage = 0;
  var isPressed = false;
  List<String> fileAttach = [];

  @override
  Widget build(BuildContext context) {
    final name = basename(widget.file.path);
    // final text = '${indexPage + 1} of $pages';

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        // actions: pages >= 2
        // ? [
        // Center(child: Text(text)),
        // IconButton(
        //   icon: const Icon(Icons.chevron_left, size: 32),
        //   onPressed: () {
        //     final page = indexPage == 0 ? pages : indexPage - 1;
        //     controller.setPage(page);
        //   },
        // ),
        // IconButton(
        //   icon: const Icon(Icons.chevron_right, size: 32),
        //   onPressed: () {
        //     final page = indexPage == pages - 1 ? 0 : indexPage + 1;
        //     controller.setPage(page);
        //   },
        // ),
        // ]
        // : null,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.mail),
        shape: RoundedRectangleBorder(
            side: const BorderSide(
                color: Colors.black26, width: 1.0, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(10.0)),
        // onPressed: () => showDialog(
        //   context: context,
        //   builder: (context) {
        //     MailPDFReport();
        //   },
        //   barrierDismissible: false,
        // ),
        backgroundColor: isPressed ? Colors.green : Colors.blue,
        onPressed: () async{
          setState(() => isPressed = !isPressed);
          final RenderBox box = context.findRenderObject() as RenderBox;
          if(widget.file.path.isNotEmpty){
            fileAttach.add(widget.file.path);
            await Share.shareFiles(
                fileAttach,
                subject: 'URL File Share',
                text: 'Hello, check your share files!',
                sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size
            );
          }
        },
      ),
      body: PDFView(
        filePath: widget.file.path,
        autoSpacing: false,
        // swipeHorizontal: true,
        pageSnap: true,
        pageFling: false,
        fitEachPage: false,
        nightMode: false,
        // fitPolicy: FitPolicy.WIDTH,
        onRender: (pages) => setState(() => this.pages = pages!),
        onViewCreated: (controller) {
          setState(() => this.controller = controller);
        },
        onPageChanged: (indexPage, _) =>
            setState(() => this.indexPage = indexPage!),
      ),
    );
  }
  // Future<> urlFileShare(context,pdfImageFile) async {
  //   // setState(() {
  //   //   button2 = true;
  //   // });
  //   final RenderBox box = context.findRenderObject();
  //   if (Platform.isAndroid) {
  //     // var url = 'https://i.ytimg.com/vi/fq4N0hgOWzU/maxresdefault.jpg';
  //     // var response = await get(url);
  //     // final documentDirectory = (await getExternalStorageDirectory())!.path;
  //     // File imgFile = File('$documentDirectory/flutter.png');
  //     // imgFile.writeAsBytesSync(response.bodyBytes);
  //
  //     Share.shareFile(
  //         File(pdfImageFile),
  //         subject: 'URL File Share',
  //         text: 'Hello, check your share files!',
  //         sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  //   }
  //   // else {
  //   //   Share.share('Hello, check your share files!',
  //   //       subject: 'URL File Share',
  //   //       sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  //   // }
  //   // setState(() {
  //   //   button2 = false;
  //   // });
  // }
}
