import 'package:Upright_NG/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show ValueListenable;

class Dots extends StatelessWidget {
  final int len;
  final ValueListenable<int> idx;
  Dots(this.idx, [this.len = 3]) : assert(idx != null);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(
        len,
        (index) {
          return AnimatedContainer(
            duration: Duration(
              milliseconds: 500,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: 5.0,
            ),
            height: 7,
            width: 7,
            decoration: BoxDecoration(
              color: idx.value == index ? appYellow : Color(0x00),
              shape: BoxShape.circle,
              border: Border.all(
                color: idx.value != index ? appWhite : Color(0x00),
                width: idx.value == index ? 0 : 1.5,
              ),
            ),
          );
        },
      ),
    );
  }
}
