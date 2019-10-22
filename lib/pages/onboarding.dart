import 'package:Upright_NG/pages/auth.dart';
import 'package:Upright_NG/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../services/storage_service.dart';

import '../components/dots.dart';

final activ = ValueNotifier(0);

class OnboardingPage extends StatelessWidget {
  final PageController cntrl = PageController();

  void attachUser(BuildContext context, [goHome = true]) {
    LocalStorage.setItem("isPrevUser", true)
        .then((val) =>
            goHome ? Navigator.pushReplacementNamed(context, "/home") : goHome)
        .catchError((val) =>
            goHome ? Navigator.pushReplacementNamed(context, "/home") : goHome);
  }

  void goToAuth(context, bool isReg, [isMembership = false]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return AuthPage(
            showHome: false,
            initialRoute: isReg ? 'login/signup' : 'login/signin',
            showBottomNav: false,
            isMembership: isMembership,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/onboard_bg.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Color(0xFFEEAE2F),
              BlendMode.darken,
            ),
          ),
        ),
        child: Stack(
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
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: <Widget>[
                      Image.asset(
                        "assets/images/woman_pose.png",
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.black38,
                          padding: EdgeInsets.only(
                            left: 30,
                            bottom: 170,
                            top: 20,
                            right: 30,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AutoSizeText(
                                "upright.",
                                style: Theme.of(context)
                                    .textTheme
                                    .display1
                                    .copyWith(
                                        color: Colors.white,
                                        fontSize: 35,
                                        fontWeight: FontWeight.w900),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: AutoSizeText(
                                  "Power doesn’t corrupt people, people corrupt power. – William Gaddis",
                                  style: Theme.of(context)
                                      .textTheme
                                      .display1
                                      .copyWith(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 20),
                                ),
                              )
                            ],
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 10.0),
                  child: Container(
                    child: Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: <Widget>[
                        Image.asset(
                          "assets/images/man_pose.png",
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: Colors.black38,
                            padding: EdgeInsets.only(
                              left: 30,
                              bottom: 80,
                              top: 20,
                              right: 30,
                            ),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 10,
                                      width: 10,
                                      decoration: BoxDecoration(
                                        color: appRed,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    AutoSizeText(
                                      "WATCH ALL VIDEOS",
                                      style: Theme.of(context)
                                          .textTheme
                                          .display1
                                          .copyWith(
                                              color: Colors.white,
                                              fontSize: 20),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                AutoSizeText(
                                  "WHO IS NOT GUILTY OF THIS IN NIGERIA?",
                                  style: Theme.of(context)
                                      .textTheme
                                      .display1
                                      .copyWith(
                                          color: Colors.white,
                                          fontSize: 35,
                                          fontWeight: FontWeight.w900),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                AutoSizeText(
                                  """There are Nigerians not guilty of this offence or sin as you may call it, but that will be only a tiny click of the entire population.""",
                                  style: Theme.of(context)
                                      .textTheme
                                      .display1
                                      .copyWith(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Center(
                            child: Container(
                              child: Icon(
                                Icons.play_arrow,
                                color: appWhite,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: appWhite,
                                  width: 1,
                                ),
                              ),
                              padding: EdgeInsets.all(10.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 10.0),
                  child: Container(
                    child: Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: <Widget>[
                        SafeArea(
                          child: Container(
                            decoration: BoxDecoration(
                              color: appBlack,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            margin: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.width * 0.13,
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.1,
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 20.0,
                              horizontal: 10.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: appWhite,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      height: 10,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: appWhite,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: Image.asset(
                                    "assets/images/profile.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                  // AspectRatio(
                                  //   aspectRatio: 3 / 7,
                                  //   child:
                                  // ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: appWhite,
                                      width: 5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: appGreen.withOpacity(0.9),
                            padding: EdgeInsets.only(
                              left: 30,
                              bottom: 80,
                              top: 20,
                              right: 30,
                            ),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                AutoSizeText(
                                  "transparency.",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .display1
                                      .copyWith(
                                          color: Colors.white,
                                          fontSize: 35,
                                          fontWeight: FontWeight.w900),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                AutoSizeText(
                                  """The worst disease in the world today is corruption. And there is a cure: transparency.""",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .display1
                                      .copyWith(
                                          color: Colors.white, fontSize: 20),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                RaisedButton(
                                  child: AutoSizeText("Create Account"),
                                  onPressed: () async {
                                    goToAuth(context, true);
                                  },
                                  color: appWhite,
                                  textColor: appGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 20,
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: <Widget>[
                                    // FlatButton(
                                    //   padding: EdgeInsets.all(0),
                                    //   child: AutoSizeText("BECOME A MEMBER"),
                                    //   textColor: appWhite,
                                    //   onPressed: () {
                                    //     goToAuth(context, true, true);
                                    //   },
                                    // ),
                                    // SizedBox(
                                    //   width: 10,
                                    // ),
                                    // AutoSizeText(
                                    //   "-",
                                    //   style: TextStyle(color: appWhite),
                                    // ),
                                    // SizedBox(
                                    //   width: 0,
                                    // ),
                                    FlatButton(
                                      padding: EdgeInsets.all(0),
                                      child: AutoSizeText("SKIP"),
                                      textColor: appWhite,
                                      onPressed: () {
                                        attachUser(context);
                                      },
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    AutoSizeText(
                                      "-",
                                      style: TextStyle(color: appWhite),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    FlatButton(
                                      padding: EdgeInsets.all(0),
                                      child: AutoSizeText("LOGIN"),
                                      textColor: appWhite,
                                      onPressed: () async {
                                        attachUser(context, false);
                                        goToAuth(context, false);
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 60.0,
              left: 0.0,
              right: 0.0,
              child: Center(
                child: ValueListenableBuilder(
                  valueListenable: activ,
                  builder: (context, val, child) {
                    return val == 3
                        ? SizedBox(
                            height: 0,
                          )
                        : Dots(activ, 3);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
