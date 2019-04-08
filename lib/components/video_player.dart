import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:line_icons/line_icons.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final String url;
  final File filePath;
  final bool isUrl;

  VideoWidget({this.url, this.filePath, this.isUrl = true});

  State<StatefulWidget> createState() {
    return _VideoWidgetState();
  }
}

class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController ctrl;

  void initState() {
    super.initState();
    if (widget.isUrl) {
      ctrl = VideoPlayerController.network(widget.url)
        ..initialize().then((_) {
          setState(() {});
        });
    } else {
      ctrl = VideoPlayerController.file(widget.filePath)
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  void dispose() {
    super.dispose();
    ctrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        !ctrl.value.initialized
            ? Center(
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoActivityIndicator()
                    : CircularProgressIndicator(),
              )
            : widget.url.endsWith(".m4a")
                ? Container(
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/waveform.png")),
                    ),
                    child: VideoPlayer(ctrl),
                  )
                : AspectRatio(
                    aspectRatio: ctrl.value.aspectRatio > 0.0
                        ? ctrl.value.aspectRatio
                        : 10.0,
                    child: VideoPlayer(ctrl),
                  ),
        Container(
          height: 30.0,
          color: Color(0xFFE8C11CAA),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  LineIcons.play,
                  color: Colors.white,
                  size: 30.0,
                ),
                onPressed: () {
                  setState(() {
                    ctrl.play();
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  LineIcons.pause,
                  color: Colors.white,
                  size: 30.0,
                ),
                onPressed: () {
                  setState(() {
                    ctrl.pause();
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  LineIcons.stop,
                  color: Colors.white,
                  size: 30.0,
                ),
                onPressed: () {
                  setState(() {
                    ctrl.pause();
                  });
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
