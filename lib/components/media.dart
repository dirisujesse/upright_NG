
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import './video_player.dart';

class MediaContainer extends StatelessWidget {
  final String id;
  final bloc;

  MediaContainer({this.id = "postMediaState", @required this.bloc});

  @override
  Widget build(BuildContext context) {
    print(bloc);
    return StateBuilder(
      stateID: id,
      blocs: [bloc],
      builder: (_) {
        if (bloc.isImg) {
          return Image.file(
            bloc.image,
            fit: BoxFit.contain,
            height: 400,
          );
        }
        if (bloc.isVid) {
          return VideoWidget(
            filePath: bloc.video,
            isUrl: false,
          );
        }
        if (bloc.isAud) {
          return VideoWidget(
            filePath: bloc.audio,
            isUrl: false,
          );
        }
        return SizedBox(
          height: 0.0,
        );
      },
    );
  }
}