import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
        ..initialize().then(
          (_) {
            setState(() {});
          },
        );
    } else {
      print(widget.filePath.uri);
      ctrl = VideoPlayerController.file(widget.filePath)
        ..initialize().then(
          (_) {
            setState(() {});
          },
        );
    }
  }

  void dispose() {
    super.dispose();
    ctrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
//      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        !ctrl.value.initialized
            ? Container(
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/waveform.png")),
                ),
                child: Center(
                  child: Theme.of(context).platform == TargetPlatform.iOS
                      ? CupertinoActivityIndicator()
                      : CircularProgressIndicator(),
                ),
              )
            : (widget.isUrl && widget.url.endsWith(".m4a")) ||
                    !(ctrl.value.aspectRatio > 0.0)
                ? Container(
                    height: 80,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/waveform.png"),
                      ),
                      color: Color(0xAAFFFFFF),
                    ),
                    // child: VideoPlayer(ctrl),
                  )
                : Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: AspectRatio(
                      aspectRatio: ctrl.value.aspectRatio,
                      child: VideoPlayer(ctrl),
                    ),
                  ),
        Positioned(
            bottom: 10.0,
            left: 0.0,
            right: 0.0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      FloatingActionButton(
                        heroTag: "volDec",
                        child: Icon(Icons.loop),
                        onPressed: () {
                          if (!ctrl.value.isLooping) {
                            setState(() {
                              ctrl.setLooping(true);
                            });
                          } else {
                            setState(() {
                              ctrl.setLooping(false);
                            });
                          }
                        },
                        backgroundColor: ctrl.value.isLooping
                            ? Color(0xAA0000AA)
                            : Color(0xAA000000),
                        mini: true,
                        elevation: 0,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      FloatingActionButton(
                        heroTag: "volInc",
                        child: Icon(Icons.mic_off),
                        onPressed: () {
                          if (ctrl.value.volume > 0.0) {
                            setState(() {
                              ctrl.setVolume(0.0);
                            });
                          } else {
                            setState(() {
                              ctrl.setVolume(20.0);
                            });
                          }
                        },
                        backgroundColor: Color(
                            ctrl.value.volume > 0.0 ? 0xAA000000 : 0xAAFF0000),
                        mini: true,
                        elevation: 0,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      FloatingActionButton(
                        heroTag: "play",
                        child: Icon(Icons.play_arrow),
                        onPressed: () {
                          setState(() {
                            if (ctrl.value.position.inMilliseconds >= ctrl.value.duration.inMilliseconds) {
                              ctrl.seekTo(Duration(microseconds: 0));
                            }
                            ctrl.play();
                          });
                        },
                        backgroundColor: Color(0xAA000000),
                        mini: true,
                        elevation: 0,
                      ),
                      FloatingActionButton(
                        heroTag: "pause",
                        child: Icon(Icons.pause),
                        onPressed: () {
                          setState(() {
                            ctrl.pause();
                          });
                        },
                        backgroundColor: Color(0xAA000000),
                        mini: true,
                        elevation: 0,
                      ),
                    ],
                  )
                ],
              ),
            ))
      ],
    );
  }
}
