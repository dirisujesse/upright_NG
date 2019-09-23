import 'dart:async';

import 'package:Upright_NG/components/app_activity_indicator.dart';
import 'package:Upright_NG/components/form_scaffold.dart';
import 'package:Upright_NG/services/http_service.dart';
import 'package:Upright_NG/stores/user.dart';
import 'package:Upright_NG/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:simple_share/simple_share.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../services/storage_service.dart';

final UserBloc activeUser = UserBloc.getInstance();

class PledgePage extends StatelessWidget {
  ValueNotifier height;
  final bool isMembership;
  final ValueNotifier isPledging = ValueNotifier(false);

  PledgePage({this.height, @required this.isMembership}) : assert(isMembership != null) {
    if (height == null) {
       height = ValueNotifier(0.3);
    }
  }

  void attachUser(BuildContext context) {
    LocalStorage.setItem("isPrevUser", true)
        .then((val) => Navigator.pushReplacementNamed(context, isMembership ? "/membership" : "/home"))
        .catchError(
            (val) => Navigator.pushReplacementNamed(context, isMembership ? "/membership" : "/home"));
  }

  void sharePledge() {
    var content =
        "I just took #TheUprightPledge to be #Upright4Nigeria. Join other upright citizens by downloading the Upright mobile app at https://play.google.com/store/apps/details?id=com.ccsi.upright";
    SimpleShare.share(
      title: "Share your pledge",
      msg: content,
    ).then((val) {
      print(val);
    }).catchError((err) {
      print(err);
    });
  }

  void makePledge() {
    isPledging.value = true;
    HttpService.pledge(activeUser.activeUser.id).then((val) {
      isPledging.value = false;
      alterHeight();
    }, onError: (err) {
      isPledging.value = false;
      alterHeight();
    });
  }

  void alterHeight() {
    height.value = 0.65;
    Timer(
      Duration(milliseconds: 500),
      () {
        height.value = 0.5;
        Timer(Duration(milliseconds: 1500), sharePledge);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: height,
      builder: (context, val, child) {
        return FormScaffold(
          bottomInset: 20,
          willPop: false,
          pageHyt: val,
          navIcon: SizedBox(),
          content: Container(
            alignment: val > 0.3 ? Alignment.center : Alignment.topCenter,
            child: ValueListenableBuilder(
              valueListenable: isPledging,
              builder: (context, isPledging, child) {
                return PledgeContent(
                  height: val,
                  alterHeight: makePledge,
                  isPledging: isPledging,
                );
              },
            ),
          ),
          bannerImage: "assets/images/man_pose.png",
          bottomNavigationBar: val == 0.5
              ? Container(
                  height: 60,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      child: AutoSizeText(
                        "Next",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: appBlack.withOpacity(0.6),
                        ),
                      ),
                      onPressed: () => attachUser(context),
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }
}

class PledgeContent extends StatelessWidget {
  final double height;
  final Function alterHeight;
  final bool isPledging;
  PledgeContent(
      {@required this.height,
      @required this.alterHeight,
      @required this.isPledging})
      : assert(height != null && alterHeight != null);

  @override
  Widget build(BuildContext context) {
    if (height == 0.3) {
      return SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 20.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AutoSizeText(
              "The Upright Pledge",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: appGreen,
                fontWeight: FontWeight.w900,
                fontSize: 25,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            AutoSizeText(
              "I STAND AGAINST CORRUPTION",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: AutoSizeText(
                """\"I pledge to play my part to make Nigeria corruption free.\n\nI will adopt a lifestyle of honesty, integrity and transparency.\n\nI will resist, discourage and report corrupt practices.\n\nI will stand Upright for Nigeria,\n\nI will stand against corruption.\n\nSo help me God.\"""",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: appBlack.withOpacity(0.6),
                ),
              ),
              // width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: formInputGreen,
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 20,
              ),
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              alignment: Alignment.center,
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton.icon(
              icon: !isPledging
                  ? SizedBox()
                  : ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 20, maxWidth: 20),
                      child: const AppSpinner(),
                    ),
              label: Container(
                child: AutoSizeText("Pledge"),
                padding: EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
              ),
              onPressed: alterHeight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            )
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 20.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            height == 0.65
                ? SizedBox(
                    height: 0,
                  )
                : Image.asset("assets/images/happy_face.png"),
            SizedBox(
              height: height == 0.65 ? 0 : 20,
            ),
            height == 0.65
                ? SizedBox(
                    height: 0,
                  )
                : Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.4,
                    ),
                    child: AutoSizeText(
                      "Thank you, go on and HIT Corruption".toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: appGreen,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                  ),
            SizedBox(
              height: height == 0.65 ? 0 : 20,
            ),
            height == 0.65
                ? CircleAvatar(
                    backgroundColor: appYellow,
                    radius: 30,
                  )
                : Image.asset("assets/images/pass_mark.png"),
          ],
        ),
      );
    }
  }
}
