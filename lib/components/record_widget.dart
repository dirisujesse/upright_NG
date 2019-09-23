
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:auto_size_text/auto_size_text.dart';

class RecordWidget extends StatelessWidget {
  final String recUsedTime;
  final Color txtCol;
  final Color bCol;
  final Function stopRecAudio;
  final Function recAudio;
  final double pos;
  final double padding;
  final bloc;

  RecordWidget({
    this.bCol,
    this.txtCol,
    this.recUsedTime,
    this.stopRecAudio,
    this.recAudio,
    this.pos,
    this.padding = 0,
    @required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    print(bloc);
    List<int> span =
        recUsedTime.split(":").map((String it) => int.parse(it)).toList();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 70.0,
          constraints: BoxConstraints(
              maxHeight: 70.0, maxWidth: constraints.maxWidth - padding),
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: txtCol,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              LinearPercentIndicator(
                progressColor: Color(0xFFE8C11C),
                percent: pos,
                backgroundColor: bCol,
                width: constraints.constrainWidth() * 0.5,
                lineHeight: 8.0,
                leading: AutoSizeText(
                  "$recUsedTime",
                  style: TextStyle(color: bCol),
                ),
                trailing: AutoSizeText(
                  "0${4 - span[0]}:${59 - span[1]}",
                  style: TextStyle(color: bCol),
                ),
              ),
              FloatingActionButton(
                heroTag: "recBtn",
                backgroundColor: bCol,
                child: Icon(
                  bloc.isRecording ? Icons.stop : Icons.mic,
                  color: txtCol,
                  size: 30,
                ),
                onPressed: () {
                  if (bloc.isRecording) {
                    stopRecAudio();
                  } else {
                    recAudio();
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }
}
