import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:line_icons/line_icons.dart';
import 'package:simple_share/simple_share.dart';

import '../services/storage_service.dart';

import '../components/dots.dart';

class OnboardingPage extends StatelessWidget {
  final PageController cntrl = PageController();
  final activ = ValueNotifier(0);

  void sharePledge(BuildContext context) {
    var content =
        "I just took #TheUprightPledge to be #Upright4Nigeria. Join other upright citizens by downloading the Upright mobile app at https://play.google.com/store/apps/details?id=com.ccsi.upright";
    SimpleShare.share(
      title: "Upright NG",
      msg: content,
    ).then((val) {
      print(val);
      attachUser(context);
    }).catchError((err) {
      print(err);
      attachUser(context);
    });
  }

  void attachUser(BuildContext context) {
    LocalStorage.setItem("isPrevUser", true)
        .then((val) => Navigator.pushReplacementNamed(context, "/home"))
        .catchError((val) => Navigator.pushReplacementNamed(context, "/home"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            controller: cntrl,
            onPageChanged: (val) {
              activ.value = val;
            },
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/tourguide01.jpg"),
                  ),
                ),
                // child: SingleChildScrollView(
                // child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/images/asset2.png'),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "Resist Corruption, Embrace Zero Tolerance for Corruption",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 23.0,
                          color: Colors.white,
                          fontFamily: 'PlayfairDisplay'),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          LineIcons.star,
                          color: Colors.white,
                        ),
                        Icon(
                          LineIcons.star,
                          color: Colors.white,
                        ),
                        Icon(
                          LineIcons.star,
                          color: Colors.white,
                        ),
                        Icon(
                          LineIcons.star,
                          color: Colors.white,
                        ),
                        Icon(
                          LineIcons.star,
                          color: Colors.white,
                        ),
                      ],
                    )
                  ],
                ),
                // ),
                // ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 30.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/tourguide02.jpg"),
                  ),
                ),
                // child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/pledge_white_md.png',
                      fit: BoxFit.contain,
                      height: 250,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "Take the Anti-Corruption Pledge",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 23.0,
                          color: Colors.white,
                          fontFamily: 'PlayfairDisplay'),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    RaisedButton(
                      color: Color(0xFFE8C11C),
                      child: Text(
                        "Pledge",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => cntrl.animateToPage(2, duration: Duration(milliseconds: 300), curve: Curves.easeIn),
                    ),
                  ],
                ),
                // ),
              ),
              Container(
                // transform: new Matrix4.rotationY(0.4),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 30.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/tourguide03.jpg"),
                  ),
                ),
                // child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/images/well_done.png'),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "Well Done",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 23.0,
                          color: Colors.white,
                          fontFamily: 'PlayfairDisplay'),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    RaisedButton(
                      color: Color(0xFFE8C11C),
                      child: Text(
                        "Share Pledge",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => sharePledge(context),
                    ),
                  ],
                ),
                // ),
              ),
            ],
          ),
          Positioned(
            bottom: 12.0,
            left: 0.0,
            right: 0.0,
            child: Center(
              child: ValueListenableBuilder(
                valueListenable: activ,
                builder: (context, val, child) {
                  return Dots(activ);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
