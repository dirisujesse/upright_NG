import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../components/text_style.dart';

class FeedPage extends StatefulWidget {
  String title;
  String id;

  FeedPage({@required this.title, @required this.id});
  @override
  State<StatefulWidget> createState() {
    return _FeedPageState();
  }
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: AppTextStyle.appHeader,
          ),
          elevation: 0.5,
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[

          ],
        ),
      ),
    );
  }
}
