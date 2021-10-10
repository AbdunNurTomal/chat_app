import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart';

class VideoViewerPage extends StatefulWidget {
  final File file;
  const VideoViewerPage({Key? key, required this.file}) : super(key: key);

  @override
  _VideoViewerPageState createState() => _VideoViewerPageState();
}

class _VideoViewerPageState extends State<VideoViewerPage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  var isPressed = false;
  List<String> fileAttach = [];

  @override
  void initState() {
    _controller = VideoPlayerController.file(File(widget.file.path));
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Report Play",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        actions: [
          IconButton(
              onPressed: () async{
                setState(() => isPressed = !isPressed);
                final RenderBox box = context.findRenderObject() as RenderBox;
                if(widget.file.path.isNotEmpty){
                  fileAttach.add(widget.file.path);
                  await Share.shareFiles(
                      fileAttach,
                      subject: 'Video Report Share',
                      text: 'Hello, check your share files!',
                      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size
                  );
                }
              },
              icon: const Icon(Icons.share_sharp)
          )
        ],
      ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator(),);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child:
        Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
      ),
    );
  }
}
