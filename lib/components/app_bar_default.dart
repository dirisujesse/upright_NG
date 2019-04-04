import 'package:flutter/material.dart';
import 'text_style.dart';
import 'upright_search.dart';

PreferredSizeWidget appBarDefault({@required String title, @required BuildContext context}) {
  return AppBar(
    leading: Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: Icon(
            Icons.menu,
            color: Color(0xFF25333D),
            size: 30.0,
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
      },
    ),
    title: Text(
      title.toUpperCase(),
      style: AppTextStyle.appHeader,
    ),
    backgroundColor: Color(0xFFFFFFFF),
    elevation: 0.5,
    centerTitle: true,
    actions: <Widget>[
      IconButton(
        icon: Icon(
          Icons.search,
          color: Color(0xFF25333D),
          size: 30.0,
        ),
        onPressed: () {
          showSearch(
            context: context,
            delegate: UprightSearchDelegate()
          );
        },
      ),
    ],
  );
}
