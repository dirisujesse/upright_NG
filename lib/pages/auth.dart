import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../components/form_style.dart';
import '../stores/user.dart';

final usrBloc = UserBloc.getInstance();

class AuthPage extends StatelessWidget {
  BuildContext ctx;
  presentSnack(
      BuildContext context, String content, Color bgCol, Color txtCol) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        content: Text(content),
        backgroundColor: bgCol,
        action: SnackBarAction(
          textColor: txtCol,
          label: "OK",
          onPressed: () {},
        ),
      ),
    );
  }

  goHome() {
    Navigator.of(ctx).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      floatingActionButton: StateBuilder(
        stateID: "authState",
        blocs: [usrBloc],
        builder: (_) {
          var vyu = !usrBloc.isLoading
              ? FloatingActionButton(
                  child: Icon(
                    Icons.home,
                    size: 30.0,
                  ),
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/home'),
                )
              : CircularProgressIndicator();
          return vyu;
        },
      ),
      body: Navigator(
        initialRoute: 'login/signin',
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case 'login/signin':
              return MaterialPageRoute(builder: (BuildContext context) {
                return LoginPage(presentSnack, goHome);
              });
              break;
            case 'login/signup':
              return MaterialPageRoute(builder: (BuildContext context) {
                return RegistrationPage(presentSnack, goHome);
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
    );
  }
}

class RegistrationPage extends StatelessWidget {
  final Function presentSnack;
  final Function goHome;

  RegistrationPage(this.presentSnack, this.goHome);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/images/tourguide02.jpg"),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Builder(
                builder: (BuildContext context) {
                  return StateBuilder(
                    stateID: "authState",
                    blocs: [usrBloc],
                    builder: (_) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextField(
                            decoration: InputDecoration(
                              labelStyle:
                                  TextStyle(color: Colors.grey, fontSize: 18.0),
                              enabledBorder: formBrdrWhite,
                              focusedBorder: formActiveBrdrWhite,
                              labelText: 'Fullname',
                              filled: false,
                            ),
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                            controller: usrBloc.signName,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              labelStyle:
                                  TextStyle(color: Colors.grey, fontSize: 18.0),
                              enabledBorder: formBrdrWhite,
                              focusedBorder: formActiveBrdrWhite,
                              labelText: 'Username',
                              filled: false,
                            ),
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                            controller: usrBloc.signUsrName,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          RaisedButton(
                            color: Color(0xFFE8C11C),
                            child: Text('REGISTER'),
                            onPressed: () {
                              if (usrBloc.signUsrName.value.text.length > 0 &&
                                  usrBloc.signName.value.text.length > 0) {
                                presentSnack(
                                    context,
                                    "Your Request is being processed",
                                    Color(0xFF004A70),
                                    Colors.pink);
                                usrBloc
                                    .signUp(usrBloc.signUsrName.value.text.trim(),
                                        usrBloc.signName.value.text.trim())
                                    .then((val) {
                                  print(val);
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
                                    "Please provide fullname and username",
                                    Color(0xFF9B0D54),
                                    Colors.blueAccent);
                              }
                            },
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "Already have an account?",
                                style: TextStyle(color: Colors.white),
                              ),
                              FlatButton(
                                child: Text(
                                  "login",
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                                onPressed: () {
                                  if (!usrBloc.isLoading) {
                                    Navigator.pushNamed(context, 'login/signin');
                                  }
                                },
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  final Function presentSnack;
  final Function goHome;

  LoginPage(this.presentSnack, this.goHome);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/images/tourguide02.jpg"),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Builder(
                builder: (BuildContext context) {
                  return StateBuilder(
                    stateID: "authState",
                    blocs: [usrBloc],
                    builder: (_) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextField(
                            decoration: InputDecoration(
                              labelStyle:
                                  TextStyle(color: Colors.grey, fontSize: 18.0),
                              enabledBorder: formBrdrWhite,
                              focusedBorder: formActiveBrdrWhite,
                              labelText: 'Username',
                              filled: false,
                            ),
                            autocorrect: false,
                            controller: usrBloc.logUsrName,
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          RaisedButton(
                            color: Color(0xFFE8C11C),
                            child: Text('LOGIN'),
                            onPressed: () {
                              if (usrBloc.logUsrName.value.text.length > 0) {
                                presentSnack(
                                    context,
                                    "Your Request is being processed",
                                    Color(0xFF004A70),
                                    Colors.pink);
                                usrBloc
                                    .login(usrBloc.logUsrName.value.text)
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
                                    "Please provide a username",
                                    Color(0xFF9B0D54),
                                    Colors.blueAccent);
                              }
                            },
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "New here?",
                                style: TextStyle(color: Colors.white),
                              ),
                              FlatButton(
                                child: Text(
                                  "register",
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                                onPressed: () {
                                  if (!usrBloc.isLoading) {
                                    Navigator.pushNamed(context, 'login/signup');
                                  }
                                },
                              )
                            ],
                          )
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
