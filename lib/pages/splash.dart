import 'package:flutter/material.dart';
import '../services/storage_service.dart';
// import 'dart:async';

class SplashWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashPage();
  }
}

class _SplashPage extends State<SplashWidget> {
  @override
  void initState() {
    Store.getItem("isPrevUser").then((prevUser) {
      if (prevUser) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        Navigator.pushReplacementNamed(context, "/welcome");
      }
    }).catchError((err) {
      print(err);
      Navigator.pushReplacementNamed(context, "/welcome");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage("assets/images/logo.jpg"),
          ),
        ),
      ),
    );
  }
}
