import 'package:Upright_NG/components/app_activity_indicator.dart';
import 'package:Upright_NG/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'package:auto_size_text/auto_size_text.dart';
import '../stores/user.dart';

final usrBloc = UserBloc.getInstance();

class AppDrawer extends StatelessWidget {
  final isHome;

  AppDrawer({this.isHome = false});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StateBuilder(
        stateID: "authState",
        blocs: [usrBloc],
        builder: (_) {
          return SafeArea(
            child: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          child: CircleAvatar(
                            backgroundColor: appYellow,
                            backgroundImage: usrBloc.isLoggedIn
                                ? NetworkImage(
                                    usrBloc.activeUser.avatar,
                                  )
                                : AssetImage("assets/images/anon.png"),
                            radius: 90,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/profile');
                          },
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        AutoSizeText(
                          usrBloc.activeUser.username,
                          style: Theme.of(context)
                              .textTheme
                              .display1
                              .copyWith(fontSize: 25),
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: appAsh,
                              size: 15,
                            ),
                            AutoSizeText(
                              "${usrBloc.activeUser.state ?? "Login"}, ${usrBloc.activeUser.country ?? "for location"}",
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    FlatButton(
                      // leading: Icon(LineIcons.home),
                      padding: EdgeInsets.all(3),
                      child: AutoSizeText(
                        'Feed',
                        style: Theme.of(context).textTheme.title,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        if (!isHome) {
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    FlatButton(
                      padding: EdgeInsets.all(3),
                      child: AutoSizeText(
                        'Acivity',
                        style: Theme.of(context).textTheme.title,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/profile');
                      },
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    FlatButton(
                      padding: EdgeInsets.all(3),
                      child: AutoSizeText(
                        'About Upright_NG',
                        style: Theme.of(context).textTheme.title,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/about');
                      },
                    ),
                    SizedBox(
                      height: usrBloc.activeUser.isMember ?? false ? 0 : 3.0,
                    ),
                    usrBloc.activeUser.isMember ?? false
                        ? SizedBox()
                        : FlatButton(
                            padding: EdgeInsets.all(3),
                            child: AutoSizeText(
                              'Become a Member',
                              style: Theme.of(context).textTheme.title,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              // Navigator.pushNamed(context, '/about');
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Join Upright Nigeria"),
                                      content: StateBuilder(
                                        stateID: "memberState",
                                        blocs: [usrBloc],
                                        builder: (_) {
                                          if (usrBloc.isUpdating) {
                                            return FractionallySizedBox(
                                              heightFactor: 0.3,
                                              child: Center(
                                                child: const AppSpinner(),
                                              ),
                                            );
                                          } else {
                                            return Text(
                                                "Confirm your decision to become a member upright_NG?");
                                          }
                                        },
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("Confirm"),
                                          onPressed: () async {
                                            final becameMember =
                                                await usrBloc.makeMember();
                                            if (becameMember) {
                                              Navigator.of(context).pop();
                                              Navigator.of(context)
                                                  .pushReplacementNamed(
                                                      "/pledge");
                                            }
                                          },
                                          color: appGreen,
                                          textColor: appWhite,
                                        ),
                                        FlatButton(
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          textColor: Colors.grey,
                                        )
                                      ],
                                    );
                                  },
                                  barrierDismissible: false);
                            },
                          ),
                    SizedBox(
                      height: 3.0,
                    ),
                    FlatButton(
                      padding: EdgeInsets.all(3),
                      child: AutoSizeText(
                        'Make a Suggestion',
                        style: Theme.of(context).textTheme.title,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/suggestions');
                      },
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    FlatButton(
                      padding: EdgeInsets.all(3),
                      child: AutoSizeText(
                        'Settings',
                        style: Theme.of(context).textTheme.title,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/settings');
                      },
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    FlatButton(
                      padding: EdgeInsets.all(3),
                      child: AutoSizeText(
                        usrBloc.isLoggedIn ? 'Logout' : 'Login',
                        style: Theme.of(context).textTheme.title,
                      ),
                      onPressed: () {
                        usrBloc.logout(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
