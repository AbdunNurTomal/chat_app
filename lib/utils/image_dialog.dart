import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:uri_to_file/uri_to_file.dart';

class ImageDialog extends StatelessWidget {
  final String imageUri;
  final String tag;

  const ImageDialog({ Key? key, required this.imageUri, required this.tag}) : super(key: key);

  //Future<File> _getLocalFile(String filename) async {
  //  String dir = (await getApplicationDocumentsDirectory()).path;
  //  File f = File('$dir/$filename');
  //  return f;
  //}
  Future<File> _getLocalFile(String filename) async {
    Uri _uri = Uri.parse(filename);
    File _file = await toFile(_uri);
    //print("File - $_file");
    return _file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: tag,
            child: FutureBuilder(
                future: _getLocalFile(imageUri),
                builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
                  print("Sanpshot - $snapshot");
                  return snapshot.data != null ? Image.file(snapshot.data!) : Container();
                }),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
