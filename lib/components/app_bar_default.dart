import 'package:flutter/material.dart';
import 'upright_search.dart';

PreferredSizeWidget appBarDefault(
    {@required String title, @required BuildContext context, Color bgCol = Colors.white, Color txtCol = Colors.black,}) {
  return AppBar(
    leading: Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: Icon(
            Icons.menu,
            color: txtCol,
            size: 30.0,
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
      },
    ),
    title: Text(
      title.toUpperCase(),
      style: TextStyle(
        color: txtCol,
        fontFamily: 'PlayFairDisplay',
        fontSize: 18.0,
      ),
    ),
    backgroundColor: bgCol,
    elevation: 0.5,
    centerTitle: true,
    actions: <Widget>[
      IconButton(
        icon: Icon(
          Icons.search,
          color: txtCol,
          size: 30.0,
        ),
        onPressed: () {
          showSearch(context: context, delegate: UprightSearchDelegate());
        },
      ),
    ],
  );
}
