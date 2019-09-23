import 'package:Upright_NG/styles/colors.dart';
import 'package:flutter/material.dart';

class UnderlineContainer extends StatelessWidget {
  final Widget prefix;
  final Widget suffix;
  final Widget title;
  final Function action;

  UnderlineContainer({
    this.prefix = const SizedBox(),
    this.suffix = const SizedBox(),
    this.title = const SizedBox(),
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 25.0,
          horizontal: 10.0,
        ),
        decoration: BoxDecoration(
          color: formInputGreen,
          border: Border(
            bottom: BorderSide(color: appGreen, width: 2),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            prefix,
            Expanded(
              child: Padding(
                child: title,
                padding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            suffix,
          ],
        ),
      ),
      onTap: () => action(),
    );
  }
}
