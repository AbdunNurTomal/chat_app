
import 'package:chat_app/utils/image_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';

class VideoProvider with ChangeNotifier{
  bool loading = false;
  String name = 'my_video.mp4';


  Future<void> videoMerger() async {
    final dir = await getExternalStorageDirectory();
    String imagePath = await ImageUtility.getImageDirPath();
    final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

    loading = true;
    notifyListeners();

    // String commandToExecute = '-r 15 -f mp3 -i ${Constants.AUDIO_PATH}' -f image2 -i ${Constants.IMAGE_PATH} -y ${Constants.OUTPUT_PATH}';
    // String commandToExecute = '-r 15 -f mp3 -i ${dir?.path}/bird.mp3 -f image2 -i $imagePath -y ${dir?.path}/$name';

    String commandToExecute = '-f image2 -framerate 1 -i $imagePath/1_%d.jpg -y ${dir?.path}/$name';
    _flutterFFmpeg.execute(commandToExecute).then((rc) => print('FFmpeg process exited with rc: $rc'));
    loading = false;
    notifyListeners();
  }
}