import 'package:flutter/material.dart';
import '../components/app_drawer.dart';
import '../components/app_bar_default.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBarDefault(title: 'HOME',),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Center(child: Text("Feeds")),
      ),
    );
  }
}
