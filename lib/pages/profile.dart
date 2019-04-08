import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:line_icons/line_icons.dart';

import '../components/form_style.dart';
import '../stores/user.dart';
import '../models/user.dart';

final usrData = UserBloc.getInstance();

class ProfilePage extends StatefulWidget {
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl;
  TextEditingController mailCtrl;
  TextEditingController cityCtrl;
  TextEditingController stateCtrl;
  TextEditingController countryCtrl;
  bool isEdit = false;

  void initState() {
    super.initState();
    final user = usrData.activeUser;
    nameCtrl = TextEditingController(text: user.name ?? "");
    mailCtrl = TextEditingController(text: user.email ?? "");
    cityCtrl = TextEditingController(text: user.city ?? "");
    stateCtrl = TextEditingController(text: user.state ?? "");
    countryCtrl = TextEditingController(text: user.country ?? "");
  }

  Widget grids(BuildContext context) {
    if (usrData.isLoadingStat) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Theme.of(context).platform == TargetPlatform.iOS
                  ? CupertinoActivityIndicator()
                  : CircularProgressIndicator(),
              Text("Loading User Stat")
            ],
          ),
        ),
      );
    } else {
      if (usrData.usrStat != null) {
        return SliverGrid.count(
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 2.0,
          crossAxisCount: 2,
          children: [
            Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Color(0xFFE8C11C),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    usrData.usrStat["posts"].toString() ?? "0",
                    style: TextStyle(fontSize: 50.0),
                  ),
                  Text(
                    "POSTS",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Color(0xFFE8C11C),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    usrData.usrStat["comments"].toString() ?? "0",
                    style: TextStyle(fontSize: 50.0),
                  ),
                  Text(
                    "COMMENTS",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Color(0xFFE8C11C),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    usrData.usrStat["upvotes"].toString() ?? "0",
                    style: TextStyle(fontSize: 50.0),
                  ),
                  Text(
                    "UPVOTES",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Color(0xFFE8C11C),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    usrData.usrStat["downvotes"].toString() ?? "0",
                    style: TextStyle(fontSize: 50.0),
                  ),
                  Text(
                    "DOWNVOTES",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ],
        );
      } else {
        return SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  LineIcons.warning,
                  size: 30.0,
                ),
                FlatButton(
                  child: Text(
                    "User stat retrieval fetch failed, retry",
                    style: TextStyle(
                      color: Color(0xFF007CBB),
                    ),
                  ),
                  onPressed: () => usrData.getUserStat(this),
                )
              ],
            ),
          ),
        );
      }
    }
  }

  Widget form(BuildContext context, User user) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          alignment: FractionalOffset.center,
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelStyle:
                          TextStyle(color: Color(0xFFCCCCCC), fontSize: 18.0),
                      enabledBorder: formBrdr,
                      focusedBorder: formActiveBrdr,
                      labelText: 'Name',
                      filled: false,
                    ),
                    controller: nameCtrl,
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelStyle:
                          TextStyle(color: Color(0xFFCCCCCC), fontSize: 18.0),
                      enabledBorder: formBrdr,
                      focusedBorder: formActiveBrdr,
                      errorBorder: errBrdr,
                      focusedErrorBorder: errBrdr,
                      labelText: 'Email',
                      filled: false,
                    ),
                    validator: (String val) {
                      if (val.isEmpty ||
                          !RegExp(r'\b[\w\d\W\D]+(?:@(?:[\w\d\W\D]+(?:\.(?:[\w\d\W\D]+))))\b')
                              .hasMatch(val)) {
                        return 'Email must be valid e.g username@mailprovider.com';
                      }
                    },
                    controller: mailCtrl,
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelStyle:
                          TextStyle(color: Color(0xFFCCCCCC), fontSize: 18.0),
                      enabledBorder: formBrdr,
                      focusedBorder: formActiveBrdr,
                      labelText: 'City',
                      filled: false,
                    ),
                    controller: cityCtrl,
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelStyle:
                          TextStyle(color: Color(0xFFCCCCCC), fontSize: 18.0),
                      enabledBorder: formBrdr,
                      focusedBorder: formActiveBrdr,
                      labelText: 'State',
                      filled: false,
                    ),
                    controller: stateCtrl,
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelStyle:
                          TextStyle(color: Color(0xFFCCCCCC), fontSize: 18.0),
                      enabledBorder: formBrdr,
                      focusedBorder: formActiveBrdr,
                      labelText: 'Country',
                      filled: false,
                    ),
                    controller: countryCtrl,
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (usrData.isLoggedIn) {
                        if (formKey.currentState.validate()) {
                          formKey.currentState.save();
                          usrData.updateUser(this, {
                            "name": nameCtrl.text.trim(),
                            "email": mailCtrl.text.trim(),
                            "city": cityCtrl.text.trim(),
                            "state": stateCtrl.text.trim(),
                            "country": countryCtrl.text.trim(),
                            "id": usrData.activeUser.id
                          }).then((val) {
                            if (val) {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Theme.of(context).accentColor,
                                  content: Text(
                                    "Your Profile has been updated",
                                  ),
                                  action: SnackBarAction(
                                    textColor: Colors.white,
                                    label: "OK",
                                    onPressed: () => "",
                                  ),
                                ),
                              );
                            } else {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Color(0xFF9B0D54),
                                  content: Text(
                                    "Sorry update failed, check that you have internet connection",
                                  ),
                                  action: SnackBarAction(
                                    textColor: Colors.blueAccent,
                                    label: "OK",
                                    onPressed: () => "",
                                  ),
                                ),
                              );
                            }
                          }).catchError((err) {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Color(0xFF9B0D54),
                                content: Text(
                                  "Sorry update failed, check that you have internet connection",
                                ),
                                action: SnackBarAction(
                                  textColor: Colors.blueAccent,
                                  label: "OK",
                                  onPressed: () => "",
                                ),
                              ),
                            );
                          });
                        } else {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Color(0xFF9B0D54),
                              content: Text(
                                "Your submission is invalid, provide valid entries",
                              ),
                              action: SnackBarAction(
                                textColor: Colors.blueAccent,
                                label: "OK",
                                onPressed: () => "",
                              ),
                            ),
                          );
                        }
                      } else {
                        Navigator.of(context).pushReplacementNamed('/login');
                      }
                    },
                    color: Color(0xFFE8C11C),
                    child: Text(
                      usrData.isLoggedIn ? "SUBMIT" : "LOGIN",
                      style: TextStyle(color: Color(0xFF25333D)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: StateBuilder(
        stateID: "profState",
        blocs: [usrData],
        builder: (_) {
          if (usrData.isLoadingStat || usrData.isUpdating) {
            return CircularProgressIndicator();
          }
          return FloatingActionButton(
            child: Icon(isEdit ? Icons.close : Icons.edit),
            onPressed: () => setState(() => isEdit = !isEdit),
          );
        },
      ),
      body: StateBuilder(
        initState: (state) => usrData.getUserStat(state),
        builder: (_) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Color(0xFF4D4E4E),
                leading: IconButton(
                  icon: Icon(
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? CupertinoIcons.back
                        : Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                expandedHeight: 250.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    usrData.activeUser.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontFamily: 'PlayfairDisplay',
                    ),
                  ),
                  background: Hero(
                    tag: usrData.activeUser.name,
                    child: Container(
                      decoration: BoxDecoration(color: Color(0xFF4D4E4E)),
                      child: Center(
                        child: CircleAvatar(
                          radius: 80,
                          backgroundImage:
                              NetworkImage(usrData.activeUser.avatar),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Builder(
                builder: (context) =>
                    isEdit ? form(context, usrData.activeUser) : grids(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
