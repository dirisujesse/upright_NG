import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import '../components/text_style.dart';

PreferredSizeWidget AppBarDefault({@required title}) {
  return AppBar(
    leading: Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: Icon(
            LineIcons.navicon,
            color: Color(0xFF25333D),
            size: 30.0,
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
      },
    ),
    title: Text(
      title,
      style: AppTextStyle.appHeader,
    ),
    backgroundColor: Color(0xFFFFFFFF),
    elevation: 0.5,
    centerTitle: true,
    actions: <Widget>[
      IconButton(
        icon: Icon(
          LineIcons.edit,
          color: Color(0xFF25333D),
          size: 30.0,
        ),
        onPressed: () {},
      )
    ],
  );
}
