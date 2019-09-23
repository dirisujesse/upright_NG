import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../styles/colors.dart';

class FormScaffold extends StatelessWidget {
  final Widget bottomNavigationBar;
  final Widget navIcon;
  final Widget content;
  final Widget drawer;
  final bool willPop;
  final String bannerImage;
  final double pageHyt;
  final double bottomInset;
  FormScaffold({
    this.bottomNavigationBar,
    @required this.navIcon,
    @required this.content,
    @required this.bottomInset,
    this.willPop = true,
    this.bannerImage = "assets/images/upright.svg",
    this.drawer,
    this.pageHyt = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return WillPopScope(
          child: Scaffold(
            drawer: drawer,
            bottomNavigationBar: bottomNavigationBar,
            body: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [appGreen, appYellow],
                      stops: [.1, .9],
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        AnimatedContainer(
                          decoration: BoxDecoration(
                            color: Color(0x00),
                            image: DecorationImage(
                              alignment: Alignment.center,
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                appWhite.withOpacity(0.05),
                                BlendMode.modulate,
                              ),
                              image: AssetImage("assets/images/pose.jpeg"),
                            ),
                          ),
                          child: Center(
                            child: BannerImage(
                              imageUrl: bannerImage,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: bannerImage.endsWith(".svg") ? 40.0 : 0,
                          ),
                          height: MediaQuery.of(context).size.height * pageHyt,
                          duration: Duration(
                            milliseconds: 300,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(
                              bottom: bottomInset,
                            ),
                            decoration: BoxDecoration(
                              color: appWhite,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                              ),
                            ),
                            child: content,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 30.0,
                  left: 10.0,
                  child: navIcon,
                )
              ],
            ),
          ),
          onWillPop: () {
            if (willPop) {
              // Navigator.of(context).pop();
              return Future.value(true);
            }
            return Future.value(false);
          },
        );
      },
    );
  }
}

class BannerImage extends StatelessWidget {
  final String imageUrl;
  BannerImage({@required this.imageUrl}) : assert(imageUrl != null);

  @override
  Widget build(BuildContext context) {
    if (imageUrl.endsWith(".svg")) {
      return SvgPicture.asset(
        imageUrl,
        color: Colors.white,
        height: 125,
        placeholderBuilder: (context) {
          return Image.asset("assets/images/asset2.png");
        },
      );
    } else {
      return Image.asset(
        imageUrl,
        fit: BoxFit.fitHeight,
        // height: 125,
      );
    }
  }
}
