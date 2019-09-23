import 'package:Upright_NG/components/page_scaffold.dart';
import 'package:Upright_NG/components/undeline_input.dart';
import 'package:Upright_NG/styles/colors.dart';
import 'package:Upright_NG/styles/form_style.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:simple_share/simple_share.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../stores/user.dart';

final usrData = UserBloc.getInstance();
const List<String> genders = ["Male", "Female", "Non Binary"];

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl;
  TextEditingController mailCtrl;
  TextEditingController cityCtrl;
  TextEditingController telCtrl;
  TextEditingController stateCtrl;
  TextEditingController countryCtrl;
  TextEditingController passCtrl;
  TextEditingController genCtrl;
  ValueNotifier<bool> allowNotif = ValueNotifier(true);
  ValueNotifier<bool> _isObscured = ValueNotifier(true);

  void initState() {
    super.initState();
    if (usrData.isEdit) {
      usrData.toggleEdit(this);
    }
    final user = usrData.activeUser;
    nameCtrl = TextEditingController(text: user.name ?? "");
    mailCtrl = TextEditingController(text: user.email ?? "");
    telCtrl = TextEditingController(text: user.telephone ?? "");
    cityCtrl = TextEditingController(text: user.city ?? "");
    stateCtrl = TextEditingController(text: user.state ?? "");
    countryCtrl = TextEditingController(text: user.country ?? "");
    passCtrl = TextEditingController(text: user.password ?? "");
    genCtrl = TextEditingController(text: user.gender ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      color: Color(0xFFF9F9F9),
      activeRoute: 4,
      appBar: AppBar(
        backgroundColor: appWhite,
        leading: BackButton(
          color: appBlack,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          )
        ],
        elevation: 0,
      ),
      child: Builder(
        builder: (context) {
          return StateBuilder(
            stateID: "profState",
            blocs: [usrData],
            builder: (_) {
              return Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
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
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                        child: Text(
                          "Settings",
                          style: Theme.of(context).textTheme.title.copyWith(
                                color: appGreen,
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                              ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: MediaQuery.of(context).size.width * 0.085,
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              TextFormField(
                                decoration: underlineInputStyle.copyWith(
                                  hintText: 'Name',
                                  prefixIcon: Icon(
                                    Icons.perm_identity,
                                    size: 25,
                                    color: appGreen,
                                  ),
                                  suffixIcon: Icon(
                                    Icons.edit,
                                    size: 25,
                                    color: appGreen,
                                  ),
                                ),
                                controller: nameCtrl,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                decoration: underlineInputStyle.copyWith(
                                  hintText: 'Email',
                                  prefixIcon: Icon(
                                    Icons.mail_outline,
                                    size: 25,
                                    color: appGreen,
                                  ),
                                ),
                                validator: (String val) {
                                  if (val.isEmpty ||
                                      !RegExp(r'\b[\w\d\W\D]+(?:@(?:[\w\d\W\D]+(?:\.(?:[\w\d\W\D]+))))\b')
                                          .hasMatch(val)) {
                                    return 'Email must be valid e.g username@mailprovider.com';
                                  }
                                  return null;
                                },
                                controller: mailCtrl,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                decoration: underlineInputStyle.copyWith(
                                  hintText: 'Telephone',
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    size: 25,
                                    color: appGreen,
                                  ),
                                ),
                                controller: telCtrl,
                                keyboardType: TextInputType.phone,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              UnderlineContainer(
                                prefix: Icon(
                                  Icons.person_pin,
                                  color: appGreen,
                                  size: 25,
                                ),
                                title: AutoSizeText(
                                  "Share your Story",
                                  textAlign: TextAlign.start,
                                ),
                                action: () {
                                  Navigator.of(context)
                                      .pushNamed("/testimonials/create");
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              UnderlineContainer(
                                prefix: Icon(
                                  Icons.share,
                                  color: appGreen,
                                  size: 25,
                                ),
                                title: AutoSizeText(
                                  "Invite",
                                  textAlign: TextAlign.start,
                                ),
                                action: () {
                                  SimpleShare.share(
                                    title: "Share App to gain points",
                                    subject:
                                        "Patake in the anti corruption drive",
                                    msg:
                                        "Join other upright citizens by downloading the Upright mobile app at https://play.google.com/store/apps/details?id=com.ccsi.upright",
                                  ).then((val) {
                                    print(val);
                                  }).catchError((err) {
                                    print(err);
                                  });
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              UnderlineContainer(
                                prefix: Icon(
                                  Icons.notifications_none,
                                  color: appGreen,
                                  size: 25,
                                ),
                                title: AutoSizeText(
                                  "Notifications",
                                  textAlign: TextAlign.start,
                                ),
                                suffix: ValueListenableBuilder(
                                  valueListenable: allowNotif,
                                  builder: (context, isAllowed, child) {
                                    return Switch.adaptive(
                                      activeColor: appGreen,
                                      value: true,
                                      onChanged: (val) =>
                                          allowNotif.value = val,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                decoration: underlineInputStyle.copyWith(
                                  hintText: 'City',
                                  prefixIcon: Icon(
                                    Icons.location_city,
                                    size: 25,
                                    color: appGreen,
                                  ),
                                ),
                                controller: cityCtrl,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                decoration: underlineInputStyle.copyWith(
                                  hintText: 'State',
                                  prefixIcon: Icon(
                                    Icons.location_searching,
                                    size: 25,
                                    color: appGreen,
                                  ),
                                ),
                                controller: stateCtrl,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                decoration: underlineInputStyle.copyWith(
                                  hintText: 'Country',
                                  prefixIcon: Icon(
                                    Icons.location_on,
                                    size: 25,
                                    color: appGreen,
                                  ),
                                ),
                                controller: countryCtrl,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              ValueListenableBuilder(
                                valueListenable: _isObscured,
                                builder: (context, val, child) {
                                  return TextFormField(
                                    decoration: underlineInputStyle.copyWith(
                                        hintText: 'Password',
                                        prefixIcon: Icon(
                                          Icons.lock_outline,
                                          size: 25,
                                          color: appGreen,
                                        ),
                                        suffixIcon: GestureDetector(
                                          child: Icon(
                                            val
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: appGreen,
                                          ),
                                          onTap: () => _isObscured.value = !val,
                                        )),
                                    obscureText: val,
                                    controller: passCtrl,
                                  );
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              ValueListenableBuilder(
                                valueListenable: genCtrl,
                                builder: (context, val, child) {
                                  return DropdownButtonFormField(
                                    decoration: underlineInputStyle.copyWith(
                                      // hintText: 'State',
                                      prefixIcon: Icon(
                                        Icons.portrait,
                                        size: 25,
                                        color: appGreen,
                                      ),
                                    ),
                                    value: genCtrl.text != "" ? genCtrl.text : null,
                                    hint: Text("Gender"),
                                    items: List.generate(genders.length, (idx) {
                                      return DropdownMenuItem(
                                        value: genders[idx],
                                        child: Text(genders[idx]),
                                      );
                                    }),
                                    onChanged: (value) {
                                      genCtrl.value =
                                          TextEditingValue(text: value);
                                    },
                                  );
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              UnderlineContainer(
                                prefix: Icon(
                                  Icons.gavel,
                                  color: appGreen,
                                  size: 25,
                                ),
                                title: AutoSizeText(
                                  "Terms and Conditions",
                                  textAlign: TextAlign.start,
                                ),
                                action: () {
                                  Navigator.of(context).pushNamed("/tncs");
                                },
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              RaisedButton(
                                onPressed: () {
                                  if (usrData.isLoggedIn) {
                                    if (formKey.currentState.validate()) {
                                      formKey.currentState.save();
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: Color(0xFF9B0D54),
                                          content: AutoSizeText(
                                            "Your profile is being updated",
                                          ),
                                          action: SnackBarAction(
                                            textColor: Colors.blueAccent,
                                            label: "OK",
                                            onPressed: () => "",
                                          ),
                                        ),
                                      );
                                      usrData.updateUser(this, {
                                        "name": nameCtrl.text.trim(),
                                        "email": mailCtrl.text.trim(),
                                        "city": cityCtrl.text.trim(),
                                        "state": stateCtrl.text.trim(),
                                        "country": countryCtrl.text.trim(),
                                        "telephone": telCtrl.text.trim(),
                                        "gender": genCtrl.text.trim(),
                                        "password": passCtrl.text.trim(),
                                      }).then((val) {
                                        if (val) {
                                          Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                              backgroundColor:
                                                  Theme.of(context).accentColor,
                                              content: AutoSizeText(
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
                                              backgroundColor:
                                                  Color(0xFF9B0D54),
                                              content: AutoSizeText(
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
                                            content: AutoSizeText(
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
                                          content: AutoSizeText(
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
                                    Navigator.of(context)
                                        .pushReplacementNamed('/login');
                                  }
                                },
                                child: AutoSizeText(
                                  usrData.isLoggedIn
                                      ? "UPDATE PROFILE"
                                      : "LOGIN",
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
