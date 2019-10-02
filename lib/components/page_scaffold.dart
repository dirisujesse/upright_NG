import 'package:Upright_NG/components/bottom_nav.dart';
import 'package:Upright_NG/styles/colors.dart';

import 'package:flutter/material.dart';

import '../components/app_drawer.dart';
import '../stores/nav_state.dart';
final navBloc = NavigationBloc.getInstance();

class PageScaffold extends StatelessWidget {
  final int activeRoute;
  final Widget child;
  final Widget floatingActionButton;
  final Widget appBar;
  final Widget bottomSheet;
  final Color color;
  final Function navWithinHome;

  PageScaffold({@required this.activeRoute, @required this.child, this.floatingActionButton, this.color = appWhite, this.navWithinHome, this.appBar, this.bottomSheet});

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
