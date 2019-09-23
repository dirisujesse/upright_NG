import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';
import '../components/app_activity_indicator.dart';

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
  final pos = ValueNotifier(0.0);

  void initState() {
    super.initState();
    if (widget.isUrl) {
      ctrl = VideoPlayerController.network(widget.url)..initialize();
    } else {
      print(widget.filePath.uri);
      ctrl = VideoPlayerController.file(widget.filePath)..initialize();
    }
    ctrl.addListener(() {
      if (ctrl.value.isPlaying) {
        pos.value = ctrl.value.position.inMilliseconds /
            ctrl.value.duration.inMilliseconds;
      }
      if (ctrl.value.position >= ctrl.value.duration) {
        pos.value = 0.0;
      }
    });
  }

  void dispose() {
    super.dispose();
    ctrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageHyt = MediaQuery.of(context).size.height;
    return ValueListenableBuilder(
      valueListenable: ctrl,
      builder: (context, val, pikin) {
        return Stack(
          children: <Widget>[
            !ctrl.value.initialized
                ? Container(
                    height: pageHyt * 0.3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/waveform.png")),
                    ),
                    child: Center(
                      child: const AppSpinner(),
                    ),
                  )
                : (widget.isUrl && widget.url.endsWith(".m4a")) ||
                        !(ctrl.value.aspectRatio > 0.0)
                    ? Container(
                        height: pageHyt * 0.2,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/waveform.png"),
                          ),
                          color: Color(0xAAFFFFFF),
                        ),
                      )
                    : Container(
                        height: pageHyt * 0.3,
                        width: MediaQuery.of(context).size.width,
                        child: AspectRatio(
                          aspectRatio: ctrl.value.aspectRatio,
                          child: VideoPlayer(ctrl),
                        ),
                      ),
            ctrl.value.initialized
                ? Positioned(
                    bottom: 10.0,
                    left: 0.0,
                    right: 0.0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          ValueListenableBuilder(
                            valueListenable: pos,
                            builder: (context, val, pikin) {
                              return VidSlider(
                                pos: pos,
                                upDatePos: (valu) {
                                  final curPos =
                                      ctrl.value.duration.inMilliseconds;
                                  pos.value = valu;
                                  final nwPos = curPos * valu;
                                  ctrl.seekTo(
                                    Duration(
                                      milliseconds: nwPos.floor(),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  FloatingActionButton(
                                    heroTag: "volDec",
                                    child: Icon(Icons.loop),
                                    onPressed: () {
                                      ctrl.setLooping(!ctrl.value.isLooping);
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
                                    child: Icon(Icons.volume_off),
                                    onPressed: () {
                                      if (ctrl.value.volume > 0.0) {
                                        ctrl.setVolume(0.0);
                                      } else {
                                        ctrl.setVolume(20.0);
                                      }
                                    },
                                    backgroundColor: Color(
                                        ctrl.value.volume > 0.0
                                            ? 0xAA000000
                                            : 0xAAFF0000),
                                    mini: true,
                                    elevation: 0,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  FloatingActionButton(
                                    heroTag: "play",
                                    child: Icon(Icons.play_arrow),
                                    onPressed: () {
                                      if (ctrl.value.position.inMilliseconds >=
                                          ctrl.value.duration.inMilliseconds) {
                                        ctrl.seekTo(Duration(microseconds: 0));
                                      }
                                      ctrl.play();
                                    },
                                    backgroundColor: Color(0xAA000000),
                                    mini: true,
                                    elevation: 0,
                                  ),
                                  FloatingActionButton(
                                    heroTag: "pause",
                                    child: Icon(Icons.pause),
                                    onPressed: () {
                                      ctrl.pause();
                                    },
                                    backgroundColor: Color(0xAA000000),
                                    mini: true,
                                    elevation: 0,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(
                    height: 0.0,
                  ),
            ctrl.value.isBuffering
                ? Positioned.fill(
                    child: Center(
                      child: const AppSpinner(),
                    ),
                  )
                : SizedBox(
                    height: 0.0,
                  ),
          ],
        );
      },
    );
  }
}

class VidSlider extends StatelessWidget {
  final Function upDatePos;
  final ValueListenable pos;

  VidSlider({this.upDatePos, this.pos});

  @override
  Widget build(BuildContext context) {
    return Slider(
      activeColor: Colors.red,
      value: pos.value,
      onChanged: (val) => upDatePos(val),
    );
  }
}
