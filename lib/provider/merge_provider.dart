
import 'dart:io';

import 'package:chat_app/utils/image_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';

class VideoProvider with ChangeNotifier{
  bool loading = false;

  Future<File> videoMerger(String videoPath) async {
    final dir = await getExternalStorageDirectory();
    String imagePath = await ImageUtility.getImageDirPath();


    // final imageDir = Directory('${dir?.path}/images');
    // List<FileSystemEntity> _images = imageDir.listSync(recursive: true, followLinks: false);
    //
    // var stringBuilder = StringBuffer();
    // stringBuilder.write("-r 1 -f mp3 -i '${dir?.path}/bird.mp3' -f image2 -framerate 1 ");
    // for(var i=0;i<_images.length;i++){
    //   var fileName = (_images[i].path.split('/').last);
    //   // print("file Name >> $fileName");
    //   stringBuilder.write(" 1 -i '$imagePath/$fileName' ");
    // }
    // var commandToExecute = "${stringBuilder.toString()} -y '${dir?.path}/my.mp4'";
    // print("command To Execute >> $commandToExecute");

    final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
    loading = true;
    notifyListeners();



/*
    var inputCommandinitial = ["-y", "-framerate", "1"];
    List<String> arrTop = [];

    //Add all paths
    for(var i=0;i<_images.length;i++){
      arrTop.add("-loop");
      arrTop.add("1");
      arrTop.add("-t");
      arrTop.add("5");
      arrTop.add("-i");
      arrTop.add(_images[i].path);
    }

    //Apply filter graph
    arrTop.add("-i");
    arrTop.add("${dir?.path}/bird.mp3");
    arrTop.add("-filter_complex");

    var stringBuilder = StringBuffer();
    for(var i=0;i<_images.length;i++){
      stringBuilder.write("[$i:v]scale=720:1280:force_original_aspect_ratio=decrease,pad=720:1280:(ow-iw)/2:(oh-ih)/2,setsar=1,fade=t=in:st=0:d=1,fade=t=out:st=5:d=1[v$i];");
    }
    for(var i=0;i<_images.length;i++){
      stringBuilder.write("[v$i]");
    }
    stringBuilder.write("fps=25,format=yuv420p[v]");
    List<String> newString = [];
    newString.add(stringBuilder.toString());

    var endcommand = ["-map", "[v]", "-map", "-c:a", "copy", "-preset", "ultrafast", "-shortest", "${dir?.path}/$name"];
    var finalCommand = (inputCommandinitial + arrTop + newString + endcommand);


  print("finalCommand $finalCommand");
  for(var i=0;i<finalCommand.length;i++){
    _flutterFFmpeg.execute(finalCommand[i]).then((rc) => print('FFmpeg process exited with rc: $rc'));
  }
*/



    // String commandToExecute = '-r 15 -f mp3 -i ${Constants.AUDIO_PATH}' -f image2 -i ${Constants.IMAGE_PATH} -y ${Constants.OUTPUT_PATH}';
    // String commandToExecute = '-r 15 -f mp3 -i ${dir?.path}/bird.mp3 -f image2 -i $imagePath -y ${dir?.path}/$name';

    // String commandToExecute = '-r 25 -f mp3 -i ${dir?.path}/bird.mp3 -f image2 -framerate 1 -i $imagePath/%d.jpg -y $videoPath';
    String commandToExecute = '-f image2 -framerate 1 -i $imagePath/%d.jpg -y $videoPath';
    _flutterFFmpeg.execute(commandToExecute).then((rc) => print('FFmpeg process exited with rc: $rc'));
    loading = false;
    notifyListeners();

    return File(videoPath);
  }
}