import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

import '../HomePage.dart';

class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  // late VideoPlayerController _controller;
  late FlickManager flickManager;
  bool isFullScreen = false;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(
          "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4"),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    return SafeArea(
      child: Stack(
        children: [
          Container(
              height: s.height / 3.5,
              child: FlickVideoPlayer(flickManager: flickManager)),],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    flickManager.dispose();
  }
}
