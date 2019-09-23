import 'package:Upright_NG/components/bottom_nav.dart';
import 'package:Upright_NG/styles/colors.dart';
// import 'package:Upright_NG/pages/feeds.dart';
// import 'package:Upright_NG/pages/post_create.dart';

import 'package:flutter/material.dart';

import '../components/app_drawer.dart';
import '../stores/nav_state.dart';

// const List<Map<String, dynamic>> pages = [
//   {
//     "url": "/feeds",
//     "icon": "assets/images/home.png",
//     "idx": 0,
//   },
//   {
//     "url": "/report",
//     "icon": "assets/images/problem.png",
//     "idx": 1,
//   },
//   {
//     "url": "/store",
//     "icon": "assets/images/gift.png",
//     "idx": 2,
//   },
//   {
//     "url": "/profile",
//     "icon": "assets/images/mans-silhouette.png",
//     "idx": 3,
//   },
//   {
//     "url": "/settings",
//     "icon": "assets/images/cogwheel.png",
//     "idx": 4,
//   },
// ];

final navBloc = NavigationBloc.getInstance();

class PageScaffold extends StatelessWidget {
  // final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
  final int activeRoute;
  final Widget child;
  final Widget floatingActionButton;
  final Widget appBar;
  final Widget bottomSheet;
  final Color color;
  final Function navWithinHome;

  PageScaffold({@required this.activeRoute, @required this.child, this.floatingActionButton, this.color = appWhite, this.navWithinHome, this.appBar, this.bottomSheet});

  // void navToPage({int pageIndex, bool useAsNav = true}) {
  //   initialRoute = pageIndex;
  //   if (useAsNav) {
  //     navKey.currentState.pushNamed(pages[pageIndex]["url"]);
  //   }
  //   navBloc.navToPage(pageIndex: pageIndex);
  // }

  void openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      drawer: AppDrawer(
        isHome: activeRoute == 0 || activeRoute == 1,
      ),
      floatingActionButton: floatingActionButton,
      body: Builder(
        builder: (BuildContext context) {
          return child;
        },
      ),
      appBar: appBar,
      bottomSheet: bottomSheet,
      bottomNavigationBar: UprightBottomNav(
        activePage: activeRoute,
        navWithinHome: navWithinHome ?? print,
      ),
    );
  }
}
