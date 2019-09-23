import 'dart:async';

import 'package:Upright_NG/components/page_scaffold.dart';
import 'package:Upright_NG/fragments/gifts.dart';
import 'package:Upright_NG/fragments/pickup.dart';
import 'package:Upright_NG/fragments/products.dart';
import 'package:Upright_NG/fragments/redemption.dart';
import 'package:Upright_NG/stores/market.dart';
import 'package:Upright_NG/styles/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

final storeBloc = StoreBloc.getInstance();

class NestContainer extends StatelessWidget {
  final Widget body;
  final String title;
  final ScrollController controller;

  NestContainer({
    @required this.body,
    @required this.title,
    @required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: controller,
      headerSliverBuilder: (context, isScrolable) {
        return [
          SliverAppBar(
            pinned: true,
            backgroundColor: appWhite,
            elevation: 5,
            expandedHeight: MediaQuery.of(context).size.height * 0.26,
            centerTitle: true,
            title: AutoSizeText(
              title,
              style: TextStyle(color: Colors.black),
            ),
            iconTheme: IconThemeData(
              color: appBlack,
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                alignment: Alignment.center,
                // height: MediaQuery.of(context).size.height * 0.25,
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: appWhite,
                  boxShadow: [
                    BoxShadow(
                      color: appShadow,
                      blurRadius: 10,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(
                        top: (MediaQuery.of(context).size.height * 0.25) * 0.3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: appGreen,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          color: appWhite,
                          fontSize: 25,
                        ),
                        children: [
                          TextSpan(
                            text: storeBloc.activeUser.activeUser.points.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          TextSpan(
                            text: " Points",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ];
      },
      body: Scrollbar(
        child: body,
      ),
    );
  }
}

class StorePage extends StatelessWidget {
  final ValueNotifier<String> title = ValueNotifier("Redeem");
  final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
  final ScrollController ctrl = ScrollController();
  final String initialRoute;
  final bool shouldPop;

  StorePage({
    this.initialRoute = "/store/products",
    this.shouldPop = true,
  });

  void navDelegate(String route, {bool isPop = false}) {
    if (isPop) {
      navState.currentState.pop();
      return;
    }
    navState.currentState.pushNamed(route);
  }

  void goToTop() {
    ctrl.animateTo(0,
        duration: Duration(milliseconds: 500), curve: Curves.linear);
  }

  void setTitle(String val) {
    title.value = val;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (navState.currentState.canPop() && shouldPop) {
          navState.currentState.pop();
          return Future.value(!true);
        } else {
          Navigator.of(context).pop();
          return Future.value(false);
        }
      },
      child: PageScaffold(
        color: Color(0xFFF7F7F7),
        activeRoute: 2,
        child: Navigator(
          initialRoute: initialRoute,
          key: navState,
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case "/store/products":
                title.value = "Redeem";
                return MaterialPageRoute(builder: (BuildContext context) {
                  return NestContainer(
                    body: ProductsFragment(router: navDelegate, navToTop: goToTop),
                    controller: ctrl,
                    title: title.value,
                  );
                });
                break;
              case "/store/orders":
                title.value = "Orders";
                return MaterialPageRoute(builder: (BuildContext context) {
                  return NestContainer(
                    body: OrdersFragment(router: navDelegate),
                    controller: ctrl,
                    title: title.value,
                  );
                });
                break;
              case "/store/redeem":
                title.value = "Successful";
                return MaterialPageRoute(builder: (BuildContext context) {
                  return NestContainer(
                    body: RedemptionFragment(router: navDelegate),
                    controller: ctrl,
                    title: title.value,
                  );
                });
                break;
              case "/store/pickup":
                title.value = "Address";
                return MaterialPageRoute(builder: (BuildContext context) {
                  return NestContainer(
                    body: PickupFragment(router: navDelegate),
                    controller: ctrl,
                    title: title.value,
                  );
                });
                break;
              default:
                title.value = "Redeem";
                return MaterialPageRoute(builder: (BuildContext context) {
                  return NestContainer(
                    body: ProductsFragment(router: navDelegate, navToTop: goToTop),
                    controller: ctrl,
                    title: title.value,
                  );
                });
            }
          },
        ),
      ),
    );
  }
}
