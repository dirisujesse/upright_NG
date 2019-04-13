import 'package:flutter/material.dart' show StatelessWidget, Widget, BuildContext, Color;
import 'package:flutter/foundation.dart' show ValueListenable;

import 'package:dots_indicator/dots_indicator.dart';

class Dots extends StatelessWidget {
  final int len;
  final ValueListenable<int> idx;
  Dots(this.idx, [this.len = 3]);

  @override
  Widget build(BuildContext context) {
    return DotsIndicator(
      numberOfDot: len,
      position: idx.value,
      dotColor: Color(0xFF2F333D),
      dotActiveColor: Color(0xFFFFFFFF),
    );
  }
}