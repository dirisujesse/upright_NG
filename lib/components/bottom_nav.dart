import 'package:flutter/material.dart';

import 'package:Upright_NG/styles/colors.dart';
import '../stores/nav_state.dart';

final navBloc = NavigationBloc.getInstance();

class UprightBottomNav extends StatelessWidget {
  final int activePage;
  final Function navWithinHome;
  UprightBottomNav({@required this.activePage, this.navWithinHome})
      : assert(activePage != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: appShadow,
            blurRadius: 2,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Table(
        children: [
          TableRow(
            children: [
              GestureDetector(
                onTap: () {
                  (activePage != 0 && activePage != 1)
                      ? Navigator.of(context).pushNamed("/home")
                      : navWithinHome(0);
                },
                child: AnimatedContainer(
                  padding: EdgeInsets.all(20.0),
                  margin: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: activePage == 0
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [appGreen, appYellow],
                          )
                        : null,
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/images/home.png",
                      color: activePage == 0 ? appWhite : appGrey,
                    ),
                  ),
                  duration: Duration(seconds: 1),
                ),
              ),
              GestureDetector(
                onTap: () {
                  (activePage != 0 && activePage != 1)
                      ? Navigator.of(context).pushNamed("/post/add/notanon")
                      : navWithinHome(1);
                },
                child: AnimatedContainer(
                  padding: EdgeInsets.all(20.0),
                  margin: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: activePage == 1
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [appGreen, appYellow],
                          )
                        : null,
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/images/problem.png",
                      color: activePage == 1 ? appWhite : appGrey,
                    ),
                  ),
                  duration: Duration(seconds: 1),
                ),
              ),
              GestureDetector(
                onTap: () {
                  activePage != 2
                      ? Navigator.of(context).pushNamed("/store")
                      : print("isHome");
                },
                child: AnimatedContainer(
                  padding: EdgeInsets.all(20.0),
                  margin: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: activePage == 2
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [appGreen, appYellow],
                          )
                        : null,
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/images/gift.png",
                      color: activePage == 2 ? appWhite : appGrey,
                    ),
                  ),
                  duration: Duration(seconds: 1),
                ),
              ),
              GestureDetector(
                onTap: () {
                  activePage != 3
                      ? Navigator.of(context).pushNamed("/profile")
                      : print("isHome");
                },
                child: AnimatedContainer(
                  padding: EdgeInsets.all(20.0),
                  margin: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: activePage == 3
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [appGreen, appYellow],
                          )
                        : null,
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/images/mans-silhouette.png",
                      color: activePage == 3 ? appWhite : appGrey,
                    ),
                  ),
                  duration: Duration(seconds: 1),
                ),
              ),
              GestureDetector(
                onTap: () {
                  activePage != 4
                      ? Navigator.of(context).pushNamed("/settings")
                      : print("isHome");
                },
                child: AnimatedContainer(
                  padding: EdgeInsets.all(20.0),
                  margin: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: activePage == 4
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [appGreen, appYellow],
                          )
                        : null,
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/images/cogwheel.png",
                      color: activePage == 4 ? appWhite : appGrey,
                    ),
                  ),
                  duration: Duration(seconds: 1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
