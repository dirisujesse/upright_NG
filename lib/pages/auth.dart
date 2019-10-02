import 'package:Upright_NG/components/app_activity_indicator.dart';
import 'package:Upright_NG/components/app_form.dart';
import 'package:Upright_NG/components/form_scaffold.dart';
import 'package:Upright_NG/pages/pledge_page.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'package:auto_size_text/auto_size_text.dart';
import '../styles/form_style.dart';
import '../styles/colors.dart';
import '../stores/user.dart';

final usrBloc = UserBloc.getInstance();
BuildContext ctx;

class AuthPage extends StatelessWidget {
  final bool showHome;
  final bool isMembership;
  final String initialRoute;
  final bool showBottomNav;

  AuthPage({
    this.showHome = true,
    this.initialRoute = 'login/signin',
    this.isMembership = false,
    this.showBottomNav = true,
  });
  presentSnack(
      BuildContext context, String content, Color bgCol, Color txtCol) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        content: AutoSizeText(content),
        backgroundColor: bgCol,
        action: SnackBarAction(
          textColor: txtCol,
          label: "OK",
          onPressed: () {},
        ),
      ),
    );
  }

  goHome({isSignUp = false}) {
    if (!isMembership && isSignUp) {
      return Navigator.of(ctx).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (ctx) {
            return PledgePage(
              height: ValueNotifier(0.5),
              isMembership: false,
            );
          },
        ),
        (routes) => false
      );
    }
    Navigator.of(ctx).pushNamedAndRemoveUntil(isSignUp ? '/pledge' : '/home', (routes) => false);
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return FormScaffold(
      bottomInset: 0,
      willPop: !showHome,
      bottomNavigationBar: !showBottomNav
          ? SizedBox()
          : Container(
              height: 60,
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.15,
              ),
              alignment: Alignment.center,
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    children: [
                      Image.asset(
                        "assets/images/efcc.jpeg",
                        height: 45,
                      ),
                      Image.asset(
                        "assets/images/police.jpeg",
                        height: 45,
                      ),
                      Image.asset(
                        "assets/images/icpc.jpg",
                        alignment: Alignment.center,
                        height: 45,
                      ),
                      Image.asset(
                        "assets/images/ndic.jpg",
                        height: 45,
                      ),
                    ],
                  )
                ],
              ),
            ),
      navIcon: showHome
          ? StateBuilder(
              stateID: "authFloatBtnState",
              blocs: [usrBloc],
              builder: (_) {
                var vyu = !usrBloc.isLoading
                    ? IconButton(
                        icon: Icon(
                          Icons.home,
                          size: 30.0,
                          color: appWhite,
                        ),
                        onPressed: () {
                          // cancelReqs();
                          Navigator.pushReplacementNamed(
                            context,
                            '/home',
                          );
                        },
                      )
                    : const AppSpinner();
                return vyu;
              },
            )
          : BackButton(),
      content: Padding(
        child: Navigator(
          initialRoute: initialRoute,
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case 'login/signin':
                return MaterialPageRoute(builder: (BuildContext context) {
                  return LoginPage(presentSnack, goHome);
                });
                break;
              case 'login/signup':
                return MaterialPageRoute(builder: (BuildContext context) {
                  return RegistrationPage(
                    presentSnack,
                    () => goHome(isSignUp: true),
                    isMembership,
                  );
                });
                break;
              default:
                return MaterialPageRoute(
                  builder: (BuildContext context) {
                    return LoginPage(presentSnack, goHome);
                  },
                );
            }
          },
        ),
        padding: EdgeInsets.only(top: 5.0, left: 30.0, right: 30.0),
      ),
    );
  }
}

class RegistrationPage extends StatelessWidget {
  final Function presentSnack;
  final Function goHome;
  final bool isMembership;
  final ValueNotifier<bool> obscureText = ValueNotifier(true);

  RegistrationPage(this.presentSnack, this.goHome, this.isMembership);

  @override
  Widget build(BuildContext context) {
    return AppForm(
      title: isMembership ? "Membership" : "Sign Up",
      subTitle: "Hello, Please fill out the form below to get started",
      formFields: Builder(
        builder: (BuildContext context) {
          return StateBuilder(
            stateID: "authRegState",
            blocs: [usrBloc],
            builder: (_) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextField(
                    decoration: formInputStyle.copyWith(
                      hintText: 'Fullname',
                      prefixIcon: Icon(
                        Icons.perm_identity,
                        size: 25,
                        color: appGreen,
                      ),
                    ),
                    controller: usrBloc.signName,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    decoration: formInputStyle.copyWith(
                      hintText: 'Username',
                      prefixIcon: Icon(
                        Icons.portrait,
                        size: 25,
                        color: appGreen,
                      ),
                    ),
                    controller: usrBloc.signUsrName,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  ValueListenableBuilder(
                    valueListenable: obscureText,
                    builder: (context, val, child) {
                      return TextField(
                        decoration: formInputStyle.copyWith(
                          hintText: 'Password',
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            size: 25,
                            color: appGreen,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () => obscureText.value = !val,
                            child: Icon(
                              val ? Icons.visibility : Icons.visibility_off,
                              color: appGreen,
                            ),
                          ),
                        ),
                        controller: usrBloc.signPassword,
                        obscureText: val,
                      );
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    child: AutoSizeText('Sign Up'),
                    onPressed: () {
                      if (usrBloc.signUsrName.value.text.length > 0 &&
                          usrBloc.signName.value.text.length > 0 &&
                          usrBloc.signPassword.value.text.length >= 5) {
                        presentSnack(context, "Your Request is being processed",
                            Color(0xFF004A70), Colors.pink);
                        usrBloc
                            .signUp(
                          usrBloc.signUsrName.value.text.trim(),
                          usrBloc.signName.value.text.trim(),
                          usrBloc.signPassword.value.text.trim(),
                          isMembership,
                        )
                            .then((val) {
                          if (!val) {
                            presentSnack(
                                context,
                                "Oops, signup failed please check that you have network connection",
                                Color(0xFF9B0D54),
                                Colors.blueAccent);
                          } else {
                            goHome();
                          }
                        });
                      } else {
                        presentSnack(
                            context,
                            "Please provide fullname and username, password should contain at least 5 characters",
                            Color(0xFF9B0D54),
                            Colors.blueAccent);
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
      helper: GestureDetector(
        child: Padding(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(text: "Already have an account? "),
                TextSpan(
                  text: "Sign In",
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: appGreen),
                ),
              ],
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          padding: EdgeInsets.all(5.0),
        ),
        onTap: () {
          if (!usrBloc.isLoading) {
            Navigator.pushNamed(context, 'login/signin');
          }
        },
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  final Function presentSnack;
  final Function goHome;
  final ValueNotifier<bool> obscureText = ValueNotifier(true);

  LoginPage(this.presentSnack, this.goHome);

  @override
  Widget build(BuildContext context) {
    return AppForm(
      title: "Sign In",
      subTitle: "Hello, Please fill out the form below to login",
      formFields: Builder(
        builder: (BuildContext context) {
          return StateBuilder(
            stateID: "authLogState",
            blocs: [usrBloc],
            builder: (_) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextField(
                    decoration: formInputStyle.copyWith(
                      hintText: 'Username',
                      prefixIcon: Icon(
                        Icons.perm_identity,
                        size: 25,
                        color: appGreen,
                      ),
                    ),
                    autocorrect: false,
                    controller: usrBloc.logUsrName,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  ValueListenableBuilder(
                    valueListenable: obscureText,
                    builder: (context, val, child) {
                      return TextField(
                        decoration: formInputStyle.copyWith(
                          hintText: 'Password',
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            size: 25,
                            color: appGreen,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () => obscureText.value = !val,
                            child: Icon(
                              val ? Icons.visibility : Icons.visibility_off,
                              color: appGreen,
                            ),
                          ),
                        ),
                        autocorrect: false,
                        controller: usrBloc.logPassword,
                        obscureText: val,
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: AutoSizeText(
                          "Forgot Password?",
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    child: AutoSizeText('Sign In'),
                    onPressed: () {
                      if (usrBloc.logUsrName.value.text.length > 0 &&
                          usrBloc.logPassword.value.text.length > 0) {
                        presentSnack(context, "Your Request is being processed",
                            Color(0xFF004A70), Colors.pink);
                        usrBloc
                            .login(usrBloc.logUsrName.value.text,
                                usrBloc.logPassword.value.text.trim())
                            .then((val) {
                          print(val);
                          if (!val) {
                            presentSnack(
                                context,
                                "Oops, login failed please check that you entered valid username or your network connection",
                                Color(0xFF9B0D54),
                                Colors.blueAccent);
                          } else {
                            goHome();
                          }
                        });
                      } else {
                        presentSnack(
                          context,
                          "Please provide a username and password",
                          Color(0xFF9B0D54),
                          Colors.blueAccent,
                        );
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
      helper: GestureDetector(
        child: Padding(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(text: "Don't have an account? "),
                TextSpan(
                  text: "Sign Up",
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: appGreen),
                ),
              ],
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          padding: EdgeInsets.all(5.0),
        ),
        onTap: () {
          if (!usrBloc.isLoading) {
            Navigator.pushNamed(context, 'login/signup');
          }
        },
      ),
    );
  }
}
