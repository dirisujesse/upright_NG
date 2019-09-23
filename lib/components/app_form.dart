import 'package:flutter/material.dart';

import '../styles/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';

class AppForm extends StatelessWidget {
  final String title;
  final String subTitle;
  final Widget helper;
  final Widget formFields;
  final EdgeInsetsGeometry padding;
  AppForm({
    @required this.title,
    @required this.subTitle,
    this.helper,
    @required this.formFields,
    this.padding
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        padding: padding,
        child: Builder(
          builder: (BuildContext context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    AutoSizeText(
                      title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.body1.copyWith(
                            color: appGreen,
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    AutoSizeText(
                      subTitle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(
                  height: 50.0,
                ),
                formFields,
                SizedBox(
                  height: this.helper != null ? 10 : 0,
                ),
                this.helper ?? SizedBox(height: 0),
                SizedBox(
                  height: 50.0,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
